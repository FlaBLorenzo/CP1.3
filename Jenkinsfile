// principal: dev test main
// agente1: dev agente1
// agente1: dev agente2



def repo = "https://github.com/mgsunir/todo-list-aws.git"
def rama = "develop"
def region="us-east-1"
def entorno="staging"


def executeBasicShellCmds(def Stagge){
    println(" Comenzando y estamos en:" + Stagge +"[ ${WORKSPACE} ] y JOB [ ${JOB_NAME} ] YY NODO:  [ ${NODE_NAME} ]")    
    sh 'whoami && hostname && uname -a '
    pwd()
    sh 'ls -la'
    sh 'echo ${region} ${entorno}'
  
    
}
pipeline {
    agent none

    stages {
      
       stage('CleanUp Workspace'){   
            agent {label "main"}
            steps {
                
                executeBasicShellCmds('CleanUp Workspace')    
                // deleteDir()
                cleanWs()
                echo "Workspace cleaned"
            }
        }
        stage('Get Code') {
            agent {label "main"}
            steps {
                executeBasicShellCmds('Get Code')
       
        
                
                // git branch: 'feature_fix_coverage', url: 'https://github.com/mgsunir/res-helloworld.git'
                // Me traigo0 la rama demandada
                git branch: "${rama}", url:  "${repo}"
                
                echo "WORKSPACE: ${env.WORKSPACE}"
                sh 'ls -la'
                
                // HAY QUE STASHEAR EL result-unit
                stash includes: 'src/**', name: 'src'
                stash includes: 'test/**', name: 'test'
                stash includes: '*.*', name : 'ficheros'
            }
        }
         stage('Static') {
            agent {label "agente1"}
            steps {
                unstash 'src'
                unstash 'test'
                unstash 'ficheros'
                catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE'){
                executeBasicShellCmds('Static')
                    script {
                        sh "python -m flake8 --exit-zero --format=pylint src/*.py >flake8.out"
                    }  
                recordIssues tools: [flake8(name: 'Flake8', pattern: 'flake8.out')],                                 qualityGates: [[threshold: 10, type: 'TOTAL', unstable: true],                                                [threshold: 11, type: 'TOTAL', unstable: false]]                     }
                
            }
        }
        
        stage('Security'){
                agent {label "agente2"}
                steps {
                    catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE'){
                        unstash 'src'
                        unstash 'test'
                        executeBasicShellCmds('Security')
                
                    
                        // Ejecutamos bandit para  pruebas de seguridad
                        sh 'python -m bandit --exit-zero -r . -f custom -o bandit.out --msg-template "{abspath}:{line}: {severity}: {test_id}: {msg}"'
                        
                    
                        // Sacamos grafica con resultados
                        recordIssues tools: [pyLint(name: 'Bandit', pattern: 'bandit.out')], qualityGates: [[threshold: 2, type: 'TOTAL', unstable: true], [threshold: 4, type: 'TOTAL', unstable: false]]    
                                                                                                  
                    }
                } 
        }
        
//                stage('Deploy'){
//                agent {label "dev"}
//                steps {
//                    catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE'){
//                        unstash 'src'
//                        unstash 'test'
//                        unstash 'ficheros'
//                        executeBasicShellCmds('Deploy')
//                        sh """
//                        
//                        # sobre que region actuo
//                        echo ${region}
//                        # hago un build
//                        sam build   --region ${region}
//                        # Hago un deploy apunto al fichero de configuracion de entornos: samconfig.toml
//                        # Se ha comentado el nombre del bucket de S3 en la seccion u se ha optado porque lo genere solo con --resolve-s3
//                        # Se ha dejado la opcion : --no-fail-on-empty-changeset por si se repite el pipeline sin cambios en template.yaml o samconfig.toml
//                        
//                        sam deploy  --region ${region}   --config-file samconfig.toml --config-env ${entorno} --resolve-s3 --no-fail-on-empty-changeset
//                        """
//                        }
//                    }
//                }

                
                stage('IntTest'){  //Testeamos con pytest
                    agent {label "main"}
                    steps{
                        executeBasicShellCmds('IntTest')
                        script {
                            def BASE_URL = sh( script: "aws cloudformation describe-stacks --stack-name todo-list-aws-staging --query 'Stacks[0].Outputs[?OutputKey==`BaseUrlApi`].OutputValue' --region us-east-1 --output text",
                            returnStdout: true)
                            env.GBASE_URL=sh( script: "echo ${BASE_URL}",returnStdout: true)
                            
                            echo "$BASE_URL"
                            echo 'Doing pytest the Whole Tests'
                            pwd()
                            // Probamos el full de metodos de la clase
                            // O con marcadores
                            // https://stackoverflow.com/questions/36456920/specify-which-pytest-tests-to-run-from-a-file
                            
                            sh "bash pipelines/common-steps/integration.sh $BASE_URL"
                            println("-------------- SOLO LECTURA ----------------")
                            println("-------------- SOLO LECTURA ----------------")
                            sh """
                                export BASE_URL=${env.GBASE_URL}
                                echo "${BASE_URL} desde ${env.GBASE_URL}"
                                pytest -s -m ro test/integration/todoApiTest.py
                                """
                }
            }
        }
        
        
        stage('IntTest2'){  //Testeamos con script custom
                    agent {label "main"}
                    steps{
                        executeBasicShellCmds('IntTest2')
                        script {
                            // def BASE_URL = sh( script: "aws cloudformation describe-stacks --stack-name todo-list-aws-staging --query 'Stacks[0].Outputs[?OutputKey==`BaseUrlApi`].OutputValue' --region us-east-1 --output text", returnStdout: true)
                            // echo "$BASE_URL"
                            pwd()
                            sh "pwd"
                            echo 'Initiating Integration Tests2'
                            sh "echo ${GBASE_URL}"
                            // sh "chmod 755 test/lanzaTestCURL.ksh"
                            sh 'bash      test/lanzaTestCURL.ksh ${GBASE_URL} '
                }
                   
            }
        } 
        
        stage('Promote'){  //Testeamos con script custom
                    agent {label "main"}
                    steps{
                        executeBasicShellCmds('Promote')
                        catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE'){
                        script {
                                pwd()
                                echo 'Promote '
                                // sh """
                                //    git branch -a
                                //    git checkout -b develop origin/develop
                                //    git checkout -b master origin/master
                                //    # git merge develop
                                //"""
                                // sh " git config --global --unset-all credential.helper"
                                
                                sh label: 'Probamos ramas y git merge', script:'bash      test/CHECK_RAMAS.ksh'
                                sshagent(credentials: ['9e0cf611-afca-4cbf-922c-f45270055d06']) { sh "git push origin master" }
                                }
                        }
                   
            }
        }
    }
}
