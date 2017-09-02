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

    openshift.withCluster() {
      openshift.doAs('openshift-token') {
        stage('test-helm') {
          def os_token = """${
            openshift.raw(
              'whoami -t'
            ).out
          }"""
          def os_url = """${
            openshift.raw(
              'whoami --show-server'
            ).out
          }"""
          echo os_url
          sh(script: "oc login --token ${os_token} ${os_url}", returnStdout: false)
          sh "oc status"
          helm.helmConfig()
        }
      }
    }

    stage('build-source-code') {
        checkout scm
        sh returnStdout: true, script: 'pwd'
        sh 'rm -rf node_modules || true'
        sh 'ln -s /usr/lib/node_modules .'
        sh 'export DEBUG=1'
        sh returnStdout: true, script: 'set -x; make build'
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