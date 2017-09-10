#!/usr/bin/groovy
def params = readJSON file: 'Jenkinsfile.json'

// Load helm shared library
@Library("github.com/camptocamp/jenkins-lib-helm")
def helm = new com.camptocamp.Helm()


podTemplate(name: 'geomapfish-builder', label: 'geomapfish', cloud: 'openshift', containers: [
    containerTemplate(
        name: 'jnlp',
        image: '172.30.1.1:5000/geomapfish-cicd/jenkins-slave-geomapfish:latest',
        ttyEnabled: true,
        command: '',
        privileged: false,
        alwaysPullImage: false,
        workingDir: '/tmp',
        args: '${computer.jnlpmac} ${computer.name}'
    )
  ]
){
  node('geomapfish'){
    withCredentials([usernamePassword(credentialsId: 'openshift-token-pw', usernameVariable: 'HELM_USER', passwordVariable: 'HELM_TOKEN')]) {
      def scmVars = checkout scm

      // set additional git envvars for image tagging
      helm.gitEnvVars()

      // tag image with version, and branch-commit_id
      def image_tags_map = helm.getContainerTags()

      // compile tag list
      def image_tags_list = helm.getMapValues(image_tags_map)

      def pwd = pwd()
      def chart_dir = "${pwd}/${params.app.chart_dir}"

      def helm_chart = params.app.name
      def openshift_subdomain = params.openshift.domain

      // define release and namespaces (Caution: release must be unique over namespaces)
      def namespace_testing = "geomapfish-testing"
      def helm_release_testing = "testing"

      def namespace_dev = "geomapfish-dev"
      def helm_release_dev = "ref-${image_tags_list.get(0)}"

      def namespace_staging = "geomapfish-staging"
      def helm_release_staging = "staging"

      def namespace_prod = "geomapfish-prod"
      def helm_release_prod = "prod"

      def debug = false
      def skip_build = false
      def skip_deploy = false
      def cleanup_dev_release = true

      if (!skip_build) {
        stage('build-applications') {
            sh returnStdout: true, script: 'pwd'
            sh 'rm -rf node_modules || true'
            sh 'ln -s /usr/lib/node_modules .'
            sh returnStdout: true, script: 'make build'
        }

        stage('build-images') {
          openshift.withCluster() {
            openshift.doAs('openshift-token') {
              openshift.withProject( 'geomapfish-cicd' ){
                parallel (
                  "print" : {
                    echo "Active project: ${openshift.project()}"
                    echo """${
                      openshift.raw(
                        'start-build',
                        'demo-geomapfish-print',
                        '--from-dir',
                        './print',
                        '--wait',
                        '--follow'
                      ).out
                    }"""
                  },
                  "mapserver" : {
                    echo """${
                      openshift.raw(
                        'start-build',
                        'demo-geomapfish-mapserver',
                        '--from-dir',
                        './mapserver',
                        '--wait',
                        '--follow'
                      ).out
                    }"""
                  },
                  "wsgi" : {
                    echo """${
                      openshift.raw(
                        'start-build',
                        'demo-geomapfish-wsgi',
                        '--from-dir',
                        './',
                        '--wait',
                        '--follow'
                      ).out
                    }"""
                  }
                )    
              }
            }
          }
        }
      }

      stage('deploy-on-testing') {
        helm.login()

        if (debug) {
          echo "---------------- scm vars ----------------------------"
          for (var in scmVars) {
            println var
          }
          echo "---------------- env vars ----------------------------"
          sh 'env > env.txt'
          for (String i : readFile('env.txt').split("\r?\n")) {
            println i
          }
        }

        // tag the latest image commit sha
        openshiftTag(
          srcStream: 'demo-geomapfish-mapserver',
          srcTag: 'latest',
          destStream: 'demo-geomapfish-mapserver',
          destTag: image_tags_list.get(0)
        )
        openshiftTag(
          srcStream: 'demo-geomapfish-print',
          srcTag: 'latest',
          destStream: 'demo-geomapfish-print',
          destTag: image_tags_list.get(0)
        )
        openshiftTag(
          srcStream: 'demo-geomapfish-wsgi',
          srcTag: 'latest',
          destStream: 'demo-geomapfish-wsgi',
          destTag: image_tags_list.get(0)
        )

        helm.helmLint(chart_dir)

        // run dry-run helm chart installation
        helm.helmDeploy(
          dry_run       : true,
          name          : helm_release_testing,
          namespace     : namespace_testing,
          chart_dir     : chart_dir,
          values : [
            "imageTag"            : image_tags_list.get(0),
            "apps.wsgi.replicas"  : 1
          ]
        )

        // run helm chart installation
        helm.helmDeploy(
          name          : helm_release_testing,
          namespace     : namespace_testing,
          chart_dir     : chart_dir,
          values : [
            "imageTag"            : image_tags_list.get(0),
            "apps.wsgi.replicas"  : 1
          ]
        )

        helm.logout()

        openshiftVerifyDeployment(
          namespace: namespace_testing,
          depCfg: "$helm_release_testing-$helm_chart-mapserver"
        )
        openshiftVerifyDeployment(
          namespace: namespace_testing,
          depCfg: "$helm_release_testing-$helm_chart-print"
        )
        openshiftVerifyDeployment(
          namespace: namespace_testing,
          depCfg: "$helm_release_testing-$helm_chart-wsgi"
        )
      }

      stage('integration-test') {
        echo  'Wait 10 seconds for app to be ready'
        sleep 10
        sh "curl -f ${helm_release_testing}-${helm_chart}-wsgi-${namespace_testing}.${openshift_subdomain}/check_collector?"
        sh "curl -f ${helm_release_testing}-${helm_chart}-wsgi-${namespace_testing}.${openshift_subdomain}/check_collector?type=all"
      }

      // deploy only the master branch
      if (scmVars.GIT_BRANCH == 'origin/dev') {
        stage('deploy-on-dev') {
          helm.login()

          // cleanup testing env
          helm.helmDelete(
            name: helm_release_testing
          )

          // run dry-run helm chart installation
          helm.helmDeploy(
            dry_run           : true,
            name              : helm_release_dev,
            tiller_namespace  : namespace_dev,
            namespace         : namespace_dev,
            chart_dir         : chart_dir,
            values : [
              "imageTag"            : image_tags_list.get(0),
              "apps.wsgi.replicas"  : 1
            ] 
          )

          // run helm chart installation
          helm.helmDeploy(
            name              : helm_release_dev,
            tiller_namespace  : namespace_dev,
            namespace         : namespace_dev,
            chart_dir         : chart_dir,
            values : [
              "imageTag"            : image_tags_list.get(0),
              "apps.wsgi.replicas"  : 1
            ] 
          )
          helm.logout()
        }
        if (cleanup_dev_release) {
          helm.login()

          // cleanup testing env
          helm.helmDelete(
            tiller_namespace  : namespace_dev,
            name:               helm_release_dev
          )
          helm.logout()
        }

      }

      // debug hook for testing env
      if (skip_deploy) {
        currentBuild.result = 'SUCCESS'
        return
      }


      // deploy only the master branch
      if (scmVars.GIT_BRANCH == 'origin/master') {
        stage('deploy-on-staging') {
          openshift.withProject( 'geomapfish-prod' ){
            // tag the latest image as staging
            openshiftTag(srcStream: 'demo-geomapfish-mapserver', srcTag: env.GIT_SHA, destStream: 'demo-geomapfish-mapserver', destTag: 'staging')
            openshiftTag(srcStream: 'demo-geomapfish-print', srcTag: env.GIT_SHA, destStream: 'demo-geomapfish-print', destTag: 'staging')
            openshiftTag(srcStream: 'demo-geomapfish-wsgi', srcTag: env.GIT_SHA, destStream: 'demo-geomapfish-wsgi', destTag: 'staging')
          }

          helm.login()

          // cleanup testing env
          helm.helmDelete(
            name: helm_release_testing
          )

          // run dry-run helm chart installation
          helm.helmDeploy(
            dry_run       : true,
            name          : helm_release_staging,
            namespace     : namespace_staging,
            chart_dir     : chart_dir,
            values : [
              "imageTag"            : image_tags_list.get(0),
              "apps.wsgi.replicas"  : 2
            ] 
          )

          // run helm chart installation
          helm.helmDeploy(
            name          : helm_release_staging,
            namespace     : namespace_staging,
            chart_dir     : chart_dir,
            values : [
              "imageTag"            : image_tags_list.get(0),
              "apps.wsgi.replicas"  : 2
            ] 
          )
          helm.logout()
        }

        stage('deploy-on-prod') {
          def promote = false
          try {
            timeout(time: 7, unit: 'DAYS') {
              promote = input message: 'Input Required',
              parameters: [
                [ $class: 'BooleanParameterDefinition',
                  defaultValue: false,
                  description: 'Check the box for a Production deployment',
                  name: 'Deploy to Production'
                ]
              ]
            }
          } catch (err) {
            // don't promote => no error
          }
          if (promote) {
            openshift.withProject( 'geomapfish-prod' ){
              // tag the latest image as staging
              openshiftTag(srcStream: 'demo-geomapfish-mapserver', srcTag: env.GIT_SHA, destStream: 'demo-geomapfish-mapserver', destTag: 'prod')
              openshiftTag(srcStream: 'demo-geomapfish-print', srcTag: env.GIT_SHA, destStream: 'demo-geomapfish-print', destTag: 'prod')
              openshiftTag(srcStream: 'demo-geomapfish-wsgi', srcTag: env.GIT_SHA, destStream: 'demo-geomapfish-wsgi', destTag: 'prod')
            }
            helm.login()

            // run dry-run helm chart installation
            helm.helmDeploy(
              dry_run       : true,
              name          : helm_release_prod,
              namespace     : namespace_prod,
              chart_dir     : chart_dir,
              values : [
                "imageTag"            : image_tags_list.get(0),
                "apps.wsgi.replicas"  : 4
              ] 
            )

            // run helm chart installation
            helm.helmDeploy(
              name          : helm_release_prod,
              namespace     : namespace_prod,
              chart_dir     : chart_dir,
              values : [
                "imageTag"            : image_tags_list.get(0),
                "apps.wsgi.replicas"  : 4
              ] 
            )
            helm.logout()
          }
        }
      }
    }
  }
}