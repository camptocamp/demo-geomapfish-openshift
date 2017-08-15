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
      // TODO
    steps {
        sh returnStdout: true, script: 'pwd'
        sh 'rm -rf node_modules || true'
        sh 'ln -s /usr/lib/node_modules .'
        sh returnStdout: true, script: 'make build'
      }
    }

    stage('build-base') {
      // TODO
      steps {
        script {
          openshift.withCluster() {
            // tell jenkins that it has to use the added global token to execute under the jenkins serviceaccount
            // running without this will cause jenkins to try with the "default" serviceaccount (which fails)
            openshift.doAs('jenkins-oc-client') {
              openshift.raw('get', 'bc')
            }
          }
        }
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