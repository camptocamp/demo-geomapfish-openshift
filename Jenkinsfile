#!/usr/bin/groovy

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

    checkout scm
    // get commit id
    sh 'git rev-parse HEAD > git_commit_id.txt'
    env.GIT_COMMIT_ID = readFile('git_commit_id.txt').trim()
    env.GIT_SHA = env.GIT_COMMIT_ID.substring(0, 7)

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

      
    openshift.withCluster() {
      openshift.doAs('openshift-token') {
        stage('build-images') {
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
                openshiftTag(srcStream: 'demo-geomapfish-print', srcTag: 'latest', destStream: 'demo-geomapfish-print', destTag: env.GIT_SHA)
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
                openshiftTag(srcStream: 'demo-geomapfish-mapserver', srcTag: 'latest', destStream: 'demo-geomapfish-mapserver', destTag: env.GIT_SHA)
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
                openshiftTag(srcStream: 'demo-geomapfish-wsgi', srcTag: 'latest', destStream: 'demo-geomapfish-wsgi', destTag: env.GIT_SHA)
              }
            )    
          }
        }

        stage('deploy-testing-env') {
          openshift.withProject( 'geomapfish-testing' ){
            parallel (
              "print" : {
                openshiftDeploy(
                  depCfg: 'demo-geomapfish-print',
                  namespace: 'geomapfish-testing'
                )
              },
              "mapserver" : {
                openshiftDeploy(
                  depCfg: 'demo-geomapfish-mapserver',
                  namespace: 'geomapfish-testing'
                )
              },
              "wsgi" : {
                openshiftDeploy(
                  depCfg: 'demo-geomapfish-wsgi',
                  namespace: 'geomapfish-testing'
                )
              }
            )              
          }
        }

        stage('tests-on-testing-env') {
          sh 'curl demo-geomapfish-wsgi-geomapfish-testing.cloudapp.openshift-poc.camptocamp.com/check_collector?'
          sh 'curl demo-geomapfish-wsgi-geomapfish-testing.cloudapp.openshift-poc.camptocamp.com/check_collector?type=all'
        }

        stage('deploy-staging-env') {
          openshift.withProject( 'geomapfish-testing' ){
            // tag the latest image as staging
            openshiftTag(srcStream: 'demo-geomapfish-mapserver', srcTag: env.GIT_SHA, destStream: 'demo-geomapfish-mapserver', destTag: 'staging')
            openshiftTag(srcStream: 'demo-geomapfish-print', srcTag: env.GIT_SHA, destStream: 'demo-geomapfish-print', destTag: 'staging')
            openshiftTag(srcStream: 'demo-geomapfish-wsgi', srcTag: env.GIT_SHA, destStream: 'demo-geomapfish-wsgi', destTag: 'staging')
          }
          openshift.withProject( 'geomapfish-staging' ){
            parallel (
              "print" : {
                openshiftDeploy(
                  depCfg: 'demo-geomapfish-print',
                  namespace: 'geomapfish-staging'
                )
              },
              "mapserver" : {
                openshiftDeploy(
                  depCfg: 'demo-geomapfish-mapserver',
                  namespace: 'geomapfish-staging'
                )
              },
              "wsgi" : {
                openshiftDeploy(
                  depCfg: 'demo-geomapfish-wsgi',
                  namespace: 'geomapfish-staging'
                )
              }
            )              
          }
        }

        stage('deploy-prd-env') {
          def promote = false
          try {
            timeout(time: 7, unit: 'DAYS') {
              promote = input message: 'Deploy to Production',
              parameters: [
                [ $class: 'BooleanParameterDefinition',
                  defaultValue: false,
                  description: 'Deploy to Production',
                  name: 'Deploy to Production'
                ]
              ]
            }
          } catch (err) {
            // don't promote => version == false, no error
          }
          if (promote) {
            openshift.withProject( 'geomapfish-testing' ){
              // tag the latest image as staging
              openshiftTag(srcStream: 'demo-geomapfish-mapserver', srcTag: env.GIT_SHA, destStream: 'demo-geomapfish-mapserver', destTag: 'staging')
              openshiftTag(srcStream: 'demo-geomapfish-print', srcTag: env.GIT_SHA, destStream: 'demo-geomapfish-print', destTag: 'staging')
              openshiftTag(srcStream: 'demo-geomapfish-wsgi', srcTag: env.GIT_SHA, destStream: 'demo-geomapfish-wsgi', destTag: 'staging')
            }
            openshift.withProject( 'geomapfish-staging' ){
              parallel (
                "print" : {
                  openshiftDeploy(
                    depCfg: 'demo-geomapfish-print',
                    namespace: 'geomapfish-staging'
                  )
                },
                "mapserver" : {
                  openshiftDeploy(
                    depCfg: 'demo-geomapfish-mapserver',
                    namespace: 'geomapfish-staging'
                  )
                },
                "wsgi" : {
                  openshiftDeploy(
                    depCfg: 'demo-geomapfish-wsgi',
                    namespace: 'geomapfish-staging'
                  )
                }
              )              
            }
          }
        }
      }
    }
  }
}