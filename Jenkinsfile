#!/usr/bin/groovy

// Load helm shared library

@Library('github.com/camptocamp/jenkins-lib-helm')
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
      checkout scm

      // set additional git envvars for image tagging
      helm.gitEnvVars()
      // tag image with version, and branch-commit_id
      def image_tags_map = helm.getContainerTags()

      // compile tag list
      def image_tags_list = helm.getMapValues(image_tags_map)

      def pwd = pwd()
      def chart_dir = "${pwd}/charts/demo-geomapfish"

      def helm_chart = "demo-geomapfish"
      def openshift_subdomain = "cloudapp.openshift-poc.camptocamp.com"

      def helm_release_testing = image_tags_list.get(0)
      def namespace_testing = "geomapfish-testing"

      def debug = true

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
    
      stage('deploy-on-testing-env') {

        checkout scm
        helm.login()

        if (debug) {
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
          version_tag   : image_tags_list.get(0),
          chart_dir     : chart_dir,
        )

        // run helm chart installation
        helm.helmDeploy(
          name          : helm_release_testing,
          namespace     : namespace_testing,
          version_tag   : image_tags_list.get(0),
          chart_dir     : chart_dir,
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

      stage('tests-on-testing-env') {
        sh "curl ${helm_release_testing}-${helm_chart}-wsgi-${namespace_testing}.${openshift_subdomain}/check_collector?"
        sh "curl ${helm_release_testing}-${helm_chart}-wsgi-${namespace_testing}.${openshift_subdomain}/check_collector?type=all"
      }

      stage('cleanup-testing-env') {
        if (!debug) {
          helm.login()
          helm.helmDelete(
            name: helm_release_testing
          )
          helm.logout()
        }
      }

      stage('deploy-on-staging-env') {
          echo "TODO"
      }

      stage('deploy-on-prod-env') {
          echo "TODO"
      }
    }
  }
}