CI/CD pipeline
1) On local machine (Ubuntu) run script from folder 1_Jenkins. It install:
   - Jenkins
   - GIT
   - Maven
   - Terraform
   - AWS
2) 





 **********/ CI  /**********
 |
 |      ---------
 |     |  Maven  |
 |      ---------
 |          ^
 |          |
 |     build code
 |          |
 |     -----------           -------------           -------------       ---------------
 |    |  Jenkins  |  <----  |  localhost  |  ---->  |  Terraform  |====>|  EC2: Tomcat  |
 |     -----------           -------------           -------------       ---------------
 |          ^
 |          |
 |      pull code
 |          |
 |     ----------
 |    |  GitHub  |
 |     ----------
 |          ^
 |          |
 |     commit code
 |          |
 |      ---------
 |     |   GIT   |
 |     ---------
 |
 **********/ CI  /********** 