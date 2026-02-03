CohortDiagnostics template repository
========================================================================================================================================================

## To create and prepare the repo
1) Create your own repo using this template:
   - OPTION 1: go to: https://github.com/oxford-pharmacoepi/CohortDiagnosticsTemplate and click the green button: Use this template --> Create new repository
   - OPTION 2: create a new repository (https://github.com/new) and on repository templates select: ocford-pharmacoepi/CohortDiagnosticsTemplate
2) Put a nice name to your repository and click create Repository (if you plan to share the code, better create the repository using as owner: oxford-pharmacoepi)
3) Add the cohort definitions that you want to use in your cohort diagnostics in the Cohorts folder.
4) Now the code is ready to run or share!

## To Run
1) Download this entire repository (you can download as a zip folder using Code -> Download ZIP, or you can use GitHub Desktop). 
2) Open the project <i>StudyCohortDiagnostics.Rproj</i> in RStudio (when inside the project, you will see its name on the top-right of your RStudio session)
3) Open and work though the <i>CodeToRun.R</i> file which should be the only file that you need to interact with. Run the lines in the file, adding your database specific information and so on (see comments within the file for instructions). The last line of this file will run the study <i>(source(here("RunStudy.R"))</i>.     
4) After running you should then have a zip folder with results to share in your output folder.

## To deploy the results
1) Use the template:: xxxx
