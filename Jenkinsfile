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

    sh 'env > env.txt'
    for (String i : readFile('env.txt').split("\r?\n")) {
      println i
    }

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
                      'status'
                    ).out
                  }"""

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

        stage('deploy-testing-env') {
          // openshift.withProject( 'geomapfish-testing' ){
          //   parallel (
          //     "print" : {
          //       openshiftDeploy(
          //         depCfg: 'demo-geomapfish-print',
          //         namespace: 'geomapfish-testing'
          //       )
          //     },
          //     "mapserver" : {
          //       openshiftDeploy(
          //         depCfg: 'demo-geomapfish-mapserver',
          //         namespace: 'geomapfish-testing'
          //       )
          //     },
          //     "wsgi" : {
          //       openshiftDeploy(
          //         depCfg: 'demo-geomapfish-wsgi',
          //         namespace: 'geomapfish-testing'
          //       )
          //     }
          //   )              
          // }
              // read in required jenkins workflow config values

          withCredentials([usernamePassword(credentialsId: 'openshift-token-pw', usernameVariable: 'HELM_USER', passwordVariable: 'HELM_TOKEN')]) {
            helm.login()

            // init helm
            helm.helmConfig()

            // set additional git envvars for image tagging
            helm.gitEnvVars()

            // tag image with version, and branch-commit_id
            def image_tags_map = helm.getContainerTags()

            // compile tag list
            def image_tags_list = helm.getMapValues(image_tags_map)

            helm.helmLint(chart_dir)

            // run dry-run helm chart installation
            helm.helmDeploy(
              dry_run       : true,
              name          : "demo-geomapfish",
              namespace     : "geomapfish-testing",
              version_tag   : image_tags_list.get(0),
              chart_dir     : chart_dir,
            )

            helm.logout()
          }
        }

        stage('tests-on-testing-env') {
          sh 'curl demo-geomapfish-wsgi-geomapfish-stage.cloudapp.openshift-poc.camptocamp.com/check_collector?'
          sh 'curl demo-geomapfish-wsgi-geomapfish-stage.cloudapp.openshift-poc.camptocamp.com/check_collector?type=all'
        }

        stage('deploy-staging-env') {
            echo "TODO"
        }

        stage('deploy-prd-env') {
            echo "TODO"
        }

      }
    }
  }
}