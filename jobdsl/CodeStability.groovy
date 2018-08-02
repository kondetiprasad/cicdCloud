job("Code Stability JobDsl") {

  logRotator(60, 20, 1, -1)

  description('Code Stability for application')

	scm {
    git {
      branch('*/dev-OrclCiCdPOC')
      remote {
        name('')
        refspec('')
        url('git@github.com:OpsTree/ContinuousIntegration.git')
      }
    }     
  }

  steps {
    maven {
      goals('install test')
      mavenInstallation('maven2')
      rootPOM('Spring3HibernateApp/pom.xml')
    }
  }

  publishers {
  	jUnitResultArchiver {
    	testResults('Spring3HibernateApp/target/surefire-reports/*.xml')
    } 
  } 
  
}
