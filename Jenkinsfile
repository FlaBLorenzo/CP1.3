// principal: dev test main
// agente1: dev agente1
// agente1: dev agente2



def repo = "https://github.com/mgsunir/todo-list-aws.git"
<<<<<<< HEAD
def rama = "master"
def region="us-east-1"
def entorno="production"
def stack_name="todo-list-aws-production"

=======
def rama = "develop"
def region="us-east-1"
def entorno="staging"
def stack_name="todo-list-aws-staging"
>>>>>>> develop

def executeBasicShellCmds(def Stagge){
    println(" Comenzando y estamos en:" + Stagge +"[ ${WORKSPACE} ] y JOB [ ${JOB_NAME} ] YY NODO:  [ ${NODE_NAME} ] ")    
    sh 'whoami && hostname && uname -a '
    pwd()
    sh 'ls -la'
    sh 'echo ${region} ${entorno}'
}

pipeline {
    agent none

    stages {
      
       stage('CleanUp Workspace Main'){   
            agent {label "main"}
            steps {
                
                executeBasicShellCmds('CleanUp Workspace Main')    
                cleanWs()
                echo "Workspace cleaned"
            }
        }
        
         stage('CleanUp Workspace Agente1'){   
            agent {label "agente1"}
            steps {
                
                executeBasicShellCmds('CleanUp Workspace Agente1')    
                cleanWs()
                echo "Workspace cleaned"
            }
        }
        
     stage('CleanUp Workspace Agente2'){   
            agent {label "agente2"}
            steps {
                
                executeBasicShellCmds('CleanUp Workspace Agente2')    
<<<<<<< HEAD
=======
                // deleteDir()
>>>>>>> develop
                cleanWs()
                echo "Workspace cleaned"
            }
        }
        
        stage('Get Code') {
            agent {label "main"}
            steps {
                executeBasicShellCmds('Get Code')
<<<<<<< HEAD
       
                // git branch: 'feature_fix_coverage', url: 'https://github.com/mgsunir/res-helloworld.git'
                // Me traigo la rama demandada
                git branch: "${rama}", url:  "${repo}"
                
                echo "WORKSPACE: ${env.WORKSPACE}"
                sh 'ls -la'
                
                // HAY QUE STASHEAR EL result-unit
=======
                echo "WORKSPACE: ${env.WORKSPACE}"
                // Me traigo del repos la rama demandada
                git branch: "${rama}", url:  "${repo}"
                
                sh 'ls -la'
                
                // HAY QUE STASHEAR EL src, test. pipelines , ficheros
>>>>>>> develop
                stash includes: 'src/**', name: 'src'
                stash includes: 'test/**', name: 'test'
                stash includes: 'pipelines/**', name: 'pipelines'
                stash includes: '*.*', name : 'ficheros'
            }
        }
<<<<<<< HEAD
      
        stage('Deploy'){
            agent {label "main"}
                steps {
                    catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE'){
                        // unstash 'src'
                        // unstash 'test'
                        // unstash 'ficheros'
=======
        
        stage('Static') {
            agent {label "agente1"}
            steps {
                unstash 'src'
                unstash 'test'
                unstash 'ficheros'
                // unstash 'pipelines' NO ES NECESARIO AQUI
                catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE'){
                executeBasicShellCmds('Static')
                    script {
                        sh "python -m flake8 --exit-zero --format=pylint src/*.py >flake8.out"
                    }  
                recordIssues tools: [flake8(name: 'Flake8', pattern: 'flake8.out')],                                 qualityGates: [[threshold: 10, type: 'TOTAL', unstable: true],                                                [threshold: 11, type: 'TOTAL', unstable: false]]                     }
                
            }
        }
        
        stage('Security'){
                agent {label "agente1"}
                steps {
                    catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE'){
                        unstash 'src'
                        unstash 'test'
                        unstash 'ficheros'
                        executeBasicShellCmds('Security')
                
                        // Ejecutamos bandit para  pruebas de seguridad
                        sh 'python -m bandit --exit-zero -r . -f custom -o bandit.out --msg-template "{abspath}:{line}: {severity}: {test_id}: {msg}"'
                        
                        // Sacamos grafica con resultados
                        recordIssues tools: [pyLint(name: 'Bandit', pattern: 'bandit.out')], qualityGates: [[threshold: 2, type: 'TOTAL', unstable: true], [threshold: 4, type: 'TOTAL', unstable: false]]    
                                                                                                  
                    }
                } 
        }
        
                stage('Deploy'){
                agent {label "main"}
                steps {
                    catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE'){
>>>>>>> develop
                        executeBasicShellCmds('Deploy')
                        sh """
                        
                        # sobre que region actuo
                        echo ${region}
                        # hago un build
                        sam build   --region ${region}
                        # Hago un deploy apunto al fichero de configuracion de entornos: samconfig.toml
                        # Se ha comentado el nombre del bucket de S3 en la seccion u se ha optado porque lo genere solo con --resolve-s3
                        # Se ha dejado la opcion : --no-fail-on-empty-changeset por si se repite el pipeline sin cambios en template.yaml o samconfig.toml
                        
                        sam deploy  --region ${region}   --config-file samconfig.toml --config-env ${entorno} --resolve-s3 --no-fail-on-empty-changeset
                        """
                        }
                    }
                }

                
<<<<<<< HEAD
        stage('RestTest'){  //Testeamos con pytest
            agent {label "agente1"}
                steps{
                        executeBasicShellCmds('RestTest')
                        unstash 'src'
                        unstash 'test'
                        unstash 'ficheros'
                        // unstash 'pipelines'
                        script {
                            def BASE_URL = sh( script: "aws cloudformation describe-stacks --stack-name ${stack_name} --query 'Stacks[0].Outputs[?OutputKey==`BaseUrlApi`].OutputValue' --region us-east-1 --output text",returnStdout: true)
                            // def BASE_URL = sh( script: "aws cloudformation describe-stacks --stack-name todo-list-aws-staging --query 'Stacks[0].Outputs[?OutputKey==`BaseUrlApi`].OutputValue' --region us-east-1 --output text",returnStdout: true)
=======
                stage('ApiRest'){  //Testeamos con pytest
                    agent {label "main"}
                    steps{
                        executeBasicShellCmds('ApiRest')
                        script {
                            //def BASE_URL = sh( script: "aws cloudformation describe-stacks --stack-name todo-list-aws-staging --query 'Stacks[0].Outputs[?OutputKey==`BaseUrlApi`].OutputValue' --region us-east-1 --output text",returnStdout: true)
                            def BASE_URL = sh( script: "aws cloudformation describe-stacks --stack-name ${stack_name} --query 'Stacks[0].Outputs[?OutputKey==`BaseUrlApi`].OutputValue' --region us-east-1 --output text",returnStdout: true)
>>>>>>> develop
                            env.GBASE_URL=sh( script: "echo ${BASE_URL}",returnStdout: true)
                            
                            echo "$BASE_URL"
                            echo 'Doing pytest the Whole Tests'
                            pwd()
<<<<<<< HEAD
                            // Probamos el full de metodos de la clase
                            // O con marcadores
                            // https://stackoverflow.com/questions/36456920/specify-which-pytest-tests-to-run-from-a-file
                            
                            //  sh "bash pipelines/common-steps/integration.sh $BASE_URL"
                            println("-------------- SOLO LECTURA ----------------")
=======
                            // TODOS LOS TESTS                            
                            sh "bash pipelines/common-steps/integration.sh $BASE_URL"

                            println("-------------- SOLO LECTURA ----------------")
                            // Probamos el full de metodos de la clase
                            // O con marcadores
                            // https://stackoverflow.com/questions/36456920/specify-which-pytest-tests-to-run-from-a-file
                            // Ha habido que añadir la eqtiqueta ro en pytest.in
>>>>>>> develop
                           
                            sh """
                                export BASE_URL=${env.GBASE_URL}
                                echo "${BASE_URL} desde ${env.GBASE_URL}"
                                pytest -s -m ro test/integration/todoApiTest.py
                                """
<<<<<<< HEAD
                        }
                    }
=======
                            }
                        }
>>>>>>> develop
                }
        
        
                stage('CurlTest'){  //Testeamos con script custom
<<<<<<< HEAD
                    agent {label "main"}
                    steps{
                        executeBasicShellCmds('CurlTest')
=======
                    agent {label "agente1"}
                    steps{
                        executeBasicShellCmds('CurlTest')
                        unstash 'src'
                        unstash 'test'
                        unstash 'ficheros'
                        
>>>>>>> develop
                        script {
                            // Aprovecho la variable global entorno GBASE_URL del step anterior y la asigno
                            // def BASE_URL = sh( script: "aws cloudformation describe-stacks --stack-name todo-list-aws-staging --query 'Stacks[0].Outputs[?OutputKey==`BaseUrlApi`].OutputValue' --region us-east-1 --output text", returnStdout: true)
                            // echo "$BASE_URL"
                            pwd()
<<<<<<< HEAD
=======
                            sh "pwd"
>>>>>>> develop
                            echo 'Initiating Integration Tests2'
                            sh "echo ${GBASE_URL}"
                            sh 'bash      test/lanzaTestCURL.ksh ${GBASE_URL} '
                        }
<<<<<<< HEAD
                    }
                }
        
        
=======
                   
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
                                sh label: 'Probamos ramas y git merge', script:'bash      test/CHECK_RAMAS.ksh'
                                // sshagent(credentials: ['githup_app']) { sh "git push origin master" }
                                }
                        }
                   
                }
        }
>>>>>>> develop
    }
}
