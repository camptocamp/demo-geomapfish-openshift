#!/usr/bin/groovy

// // Load shared library
// @Library('github.com/camptocamp/c2c-pipeline-library@master') import static com.camptocamp.utils.*

pipeline {
  agent {
    kubernetes {
      label 'geomapfish'
      containerTemplate {
        name 'jnlp'
        image 'geomapfish-cicd/openshift-jenkins-slave-geomapfish'
        ttyEnabled true
        command ''
        args '${computer.jnlpmac} ${computer.name}'
        workingDir '/tmp'
      }
    }
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
                      'demo-geomapfish-wsgi',
                      '--from-dir',
                      './',
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
        echo "TODO"
      }
    }

    stage('test-staging') {
      steps {
        echo "TODO"
      }
    }

    stage('deploy-preprod') {
      steps {
        echo "TODO"
      }
    }

    stage('deploy-prod') {
      steps {
        echo "TODO"
      }
    }
  }
}