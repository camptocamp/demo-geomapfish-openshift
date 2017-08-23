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
      openshift.doAs('eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJnZW9tYXBmaXNoLWNpY2QiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlY3JldC5uYW1lIjoiamVua2lucy10b2tlbi0yY2x2eiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJqZW5raW5zIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiMGFiMGUwOTktODdlMS0xMWU3LTk1ZjgtZmExNjNlYzA3ZjExIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omdlb21hcGZpc2gtY2ljZDpqZW5raW5zIn0.XG1b8cvqRJHIoxKSPwOVdKFCvuBwBM_Xp99jUUXYPyt0jS6he_XEefAtVMlZZplUYJ1O9ifNcQpTjpZQFxWoPQ-Vjfzk-V0R1r53DXY8fvYwi0-T-bMDNl9IFv8DMmCRfz0vW1DjeIc6_emdKsVpdNQ4Nxf3cCPoVaZ0k6ElBnyq5FaIWL4TI-oGs4PkWrFgwBlHEVgMEfoOwJnPb9ashk2k53lMl4e-_wvOhaaeeoKFhsBv2u2xazaqV7ZygP5AE0yW9KlwECr7wncky97eZAoqaJFl3YoPEBmygEB2bNUBp1J9W_2yeRYm5fmohvVBmLgENgaNVWKH9ycnFeWSMg') {
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
            // "mapserver" : {
            //   echo """${
            //     openshift.raw(
            //       'start-build',
            //       'demo-geomapfish-mapserver',
            //       '--from-dir',
            //       './mapserver',
            //       '--wait',
            //       '--follow'
            //     ).out
            //   }"""
            // },
            // "wsgi" : {
            //   echo """${
            //     openshift.raw(
            //       'start-build',
            //       'demo-geomapfish-wsgi',
            //       '--from-dir',
            //       './',
            //       '--wait',
            //       '--follow'
            //     ).out
            //   }"""
            // }
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
  }
