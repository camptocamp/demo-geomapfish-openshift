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

    def pwd = pwd()
    def chart_dir = "${pwd}/charts/demo-geomapfish"

    stage('build-source-code') {
        checkout scm
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
  
    stage('deploy-testing-env') {
      checkout scm
      withCredentials([usernamePassword(credentialsId: 'openshift-token-pw', usernameVariable: 'HELM_USER', passwordVariable: 'HELM_TOKEN')]) {
        helm.login()

        // set additional git envvars for image tagging
        helm.gitEnvVars()

        sh 'env > env.txt'
        for (String i : readFile('env.txt').split("\r?\n")) {
          println i
        }

        // tag image with version, and branch-commit_id
        def image_tags_map = helm.getContainerTags()

        // compile tag list
        def image_tags_list = helm.getMapValues(image_tags_map)

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
          name          : "testing",
          namespace     : "geomapfish-testing",
          version_tag   : image_tags_list.get(0),
          chart_dir     : chart_dir,
        )

        // run helm chart installation
        helm.helmDeploy(
          name          : "testing",
          namespace     : "geomapfish-testing",
          version_tag   : image_tags_list.get(0),
          chart_dir     : chart_dir,
        )

        helm.logout()


        openshiftVerifyDeployment(
          namespace: 'geomapfish-testing',
          depCfg: 'testing-demo-geomapfish-mapserver'
        )
        openshiftVerifyDeployment(
          namespace: 'geomapfish-testing',
          depCfg: 'testing-demo-geomapfish-print'
        )
        openshiftVerifyDeployment(
          namespace: 'geomapfish-testing',
          depCfg: 'testing-demo-geomapfish-wsgi'
        )
      }
    }

    stage('tests-on-testing-env') {
      sh 'curl testing-demo-geomapfish-wsgi-geomapfish-testing.cloudapp.openshift-poc.camptocamp.com/check_collector?'
      sh 'curl testing-demo-geomapfish-wsgi-geomapfish-testing.cloudapp.openshift-poc.camptocamp.com/check_collector?type=all'
    }

    stage('cleanup-testing-env') {
      // withCredentials([usernamePassword(credentialsId: 'openshift-token-pw', usernameVariable: 'HELM_USER', passwordVariable: 'HELM_TOKEN')]) {
      //   helm.login()
      //   helm.helmDelete(
      //     name: "testing"
      //   )
      //   helm.logout()
      // }
    }

    stage('deploy-staging-env') {
        echo "TODO"
    }

    stage('deploy-prd-env') {
        echo "TODO"
    }

  }
}