#!/usr/bin/groovy

// // Load shared library
// @Library('github.com/camptocamp/c2c-pipeline-library@master') import static com.camptocamp.utils.*

pipeline {
  agent {
    // run with the custom geomapfish slave
    // will dynamically provision a new pod on Openshift
    label 'geomapfish'
  }

  stages {

    stage('build-base') {
      steps {
        sh returnStdout: true, script: 'pwd'
        sh 'rm -rf node_modules || true'
        sh 'ln -s /usr/lib/node_modules .'
        sh 'export DEBUG=1'
        sh returnStdout: true, script: 'make build'
      }
    }

    stage('build-images') {
      steps {
        script {
          openshift.withCluster() {
            openshift.doAs('jenkins-oc-client') {
              echo "${openshift.raw( "version" ).out}"
              echo "In project: ${openshift.project()}"
            }
          } 
        } 

        parallel (
          "print" : {
            script {
              openshift.withCluster() {
                openshift.doAs('jenkins-oc-client') {
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
                }
              }
            }
          },
          "mapserver" : {
            script {
              openshift.withCluster() {
                // tell jenkins that it has to use the added global token to execute under the jenkins serviceaccount
                openshift.doAs('jenkins-oc-client') {
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
                }
              }
            }
          },
          "wsgi" : {
            script {
              openshift.withCluster() {
                openshift.doAs('jenkins-oc-client') {
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
                }
              }
            }
          }
        )    
      }
    }

    stage('deploy-staging') {
      steps {
        sh 'ls'
        // TODO
      }
    }

    stage('deploy-preprod') {
      steps {
        sh 'pwd'
        // TODO
      }
    }

    stage('deploy-prod') {
      steps {
        sh 'pwd'
      }
    }
  }
}