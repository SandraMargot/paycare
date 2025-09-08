pipeline {
  agent any
  options {
    skipDefaultCheckout(true)
    timestamps()
  }
  environment {
    PY_IMAGE     = 'python:3.10'
    DOCKER_IMAGE = "paycare-etl:${env.BUILD_NUMBER}"
    INPUT_FILE   = "${env.WORKSPACE}/data/input_data.csv"
    OUTPUT_FILE  = "${env.WORKSPACE}/data/output_data.csv"
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Unit Tests') {
      steps {
        sh '''
          docker run --rm -v "$WORKSPACE":/app -w /app ${PY_IMAGE} bash -lc '
            pip install -r requirements.txt &&
            pytest tests --junitxml=unit-tests.xml
          '
        '''
      }
      post { always { junit 'unit-tests.xml' } }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t "$DOCKER_IMAGE" .'
      }
    }

    stage('Prepare IO files') {
      steps {
        sh '''
          cat > "$INPUT_FILE" <<EOF
employee_id,employee_name,salary
101,Alice,5000
102,Bob,7000
EOF
          rm -f "$OUTPUT_FILE" || true
        '''
      }
    }

    stage('Run Container') {
      steps {
        sh '''
          docker run --rm \
            -v "$WORKSPACE/data":/app/data \
            "$DOCKER_IMAGE"
        '''
      }
    }
  }

  post {
    success {
      archiveArtifacts artifacts: 'data/output_data.csv', fingerprint: true
      echo '✅ ETL Pipeline completed successfully.'
    }
    failure {
      echo '❌ ETL Pipeline failed.'
    }
  }
}