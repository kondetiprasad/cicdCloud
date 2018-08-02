mavenJob("Deployment jobdsl") {

  logRotator(60, 20, 1, -1)

  description('Release for application')

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

  goals('clean package')
  rootPOM('Spring3HibernateApp/pom.xml')
  mavenInstallation('maven2')
  postBuildSteps {
    shell('#!/bin/bash\nfor az in a b\ndo\nssh -t -t root@dev.app.az.${az}.xebia.training.com "service tomcat-xebia stop; rm -rf /srv/tomcat/xebia/webapps/*"\nscp Spring3HibernateApp/target/Spring3HibernateApp.war root@dev.app.az.${az}.xebia.training.com:/srv/tomcat/xebia/webapps/Spring3HibernateApp.war\nssh -t -t root@dev.app.az.${az}.xebia.training.com "chown tomcat. /srv/tomcat/xebia/webapps/Spring3HibernateApp.war; service tomcat-xebia start"\ndone\n')
  }
}
