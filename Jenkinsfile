#!/usr/bin/groovy

// // Load shared library
// @Library('github.com/camptocamp/c2c-pipeline-library@master') import static com.camptocamp.utils.*

// podTemplate(name: 'geomapfish-builder', label: 'geomapfish', cloud: 'openshift', containers: [
//     containerTemplate(
//         name: 'jnlp',
//         image: '172.30.1.1:5000/geomapfish-cicd/jenkins-slave-geomapfish:latest',
//         ttyEnabled: true,
//         command: '',
//         privileged: false,
//         alwaysPullImage: false,
//         workingDir: '/tmp',
//         args: '${computer.jnlpmac} ${computer.name}'
//     )
//   ]
// ){
  node('geomapfish'){

    // stage('build-base') {
    //     checkout scm
    //     sh returnStdout: true, script: 'pwd'
    //     sh 'rm -rf node_modules || true'
    //     sh 'ln -s /usr/lib/node_modules .'
    //     sh 'export DEBUG=1'
    //     sh returnStdout: true, script: 'make build'
    // }

    openshift.withCluster() {
      openshift.doAs('openshift-token') {
        openshift.withProject( 'geomapfish-cicd' )
          stage('build-images') {
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
                    '-n',
                    'geomapfish-cicd',
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
        openshift.withProject( 'geomapfish-stage' )
          stage('deploy-staging') {
              echo "TODO"
          }

          stage('test-staging') {
              echo "TODO"
          }
        }
        stage('deploy-preprod') {
            echo "TODO"
        }

        stage('deploy-prod') {
            echo "TODO"
        }
      }
    }
  }
