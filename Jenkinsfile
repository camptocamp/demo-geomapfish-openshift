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

    stage('build-base') {
        checkout scm
        sh returnStdout: true, script: 'pwd'
        sh 'rm -rf node_modules || true'
        sh 'ln -s /usr/lib/node_modules .'
        sh 'export DEBUG=1'
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
        stage('deploy-staging') {
          openshift.withProject( 'geomapfish-stage' ){
            openshiftDeploy(
              depCfg: 'demo-geomapfish-print',
              namespace: 'geomapfish-stage'
            )
            openshiftDeploy(
              depCfg: 'demo-geomapfish-mapserver',
              namespace: 'geomapfish-stage'
            )
            openshiftDeploy(
              depCfg: 'demo-geomapfish-wsgi',
              namespace: 'geomapfish-stage'
            )
          }
        }

        stage('test-staging') {
          sh 'curl http://demo-geomapfish-wsgi.geomapfish-stage.svc:8480/check_collector?'
          sh 'curl http://demo-geomapfish-wsgi.geomapfish-stage.svc:8480/check_collector?type=all'
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
