# Integration-Services-Automation
**Automation mechanisms for the Integration Services with Power Shell**

Using the SSIS Server with the SQL Server Agent you have many options to execute SSIS-Packages dynamically. In the SQL Server Management Studio the packages can organized, managed and executed with different configurations.


An example of a SSIS Server could be:
![SSISDB objecs](https://www.ceteris.ag/wp-content/uploads/2017/10/SSIS_Server.png)

The root element of the SSIS Server is the Integration Services Catalog. Below this node you can organize several projects in different folders. Every project can assigned to one or more environments of the same folder. Our 'Environment 1' could be the development environment where the connection string contains the development database, the 'Environment 2' is the productive environment.

No there are the followed questions:
- What you have to do when you want to get a knew configuration for tests or quality assurance?
- What you also have to do when you want to separate your development packages from my productive ones?

It's a tedious error-prone process. You have to create two new environments at your own in the Folder 1 and then four environments in the Folder 2. Afterwards you have to register all variables. Here CIsa can help us with automation.

**What is CIsa?**

CIsa (Ceteris Integration-Services-Automation) is a module from the company Ceteris AG from Berlin to automate these processes. Powershell functions can interact with the SSIS Server and create, delete or copy objects and also environments. For our above-mentioned example we only need the followed lines:

[Code]

Then you can 'push the button' and let the script does the work. Afterwards you only have to change the values of the variables in the new environments. With CIsa and in particular with the copy function now we love to create new environments ;)

**May I use CIsa?**

Yes! CIsa you can download it for free. There also are more demos and detailed informations.




**Demos**

At the moment some small demos can be found in this repo and will be in more detail described in the near future.


