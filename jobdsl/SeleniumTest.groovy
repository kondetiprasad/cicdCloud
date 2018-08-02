mavenJob("Selenimun Test JobDsl") {

  logRotator(60, 20, 1, -1)

  description('Selenium Test for application')

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

  wrappers {
    xvfb('Default') {
    }
  }

  goals('clean install')
  rootPOM('EmployeeAutomation/pom.xml')
  mavenInstallation('maven2')

  publishers {
    publishHtml {
     report('EmployeeAutomation/target/surefire-reports') {
        reportName('HTML Report')
        reportFiles('index.html')
      }
    }
  }
}
