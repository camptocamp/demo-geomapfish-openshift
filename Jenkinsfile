#!/usr/bin/groovy

// // Load shared library
// @Library('github.com/camptocamp/c2c-pipeline-library@master') import static com.camptocamp.utils.*

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
        parallel (
          "print" : {
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
          },
          "mapserver" : {
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
          },
          "wsgi" : {
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
        )    
    }

    stage('deploy-staging') {
        echo "TODO"
    }

    stage('test-staging') {
        echo "TODO"
    }

    stage('deploy-preprod') {
        echo "TODO"
    }

    stage('deploy-prod') {
        echo "TODO"
    }
  }
}
