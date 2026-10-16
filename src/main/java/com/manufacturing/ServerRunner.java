package com.manufacturing;

import org.apache.catalina.Context;
import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

import java.io.File;

public class ServerRunner {
    public static void main(String[] args) throws Exception {
        int port = 8085;
        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);
        tomcat.getConnector();

        // Ensure parent classloader can find Tomcat descriptor classes
        tomcat.getEngine().setParentClassLoader(ServerRunner.class.getClassLoader());

        String webappDirLocation = new File("src/main/webapp").getAbsolutePath();
        Context ctx = tomcat.addWebapp("", webappDirLocation);

        File additionWebInfClasses = new File("target/classes");
        if (additionWebInfClasses.exists()) {
            WebResourceRoot resources = new StandardRoot(ctx);
            resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes",
                    additionWebInfClasses.getAbsolutePath(), "/"));
            ctx.setResources(resources);
        }

        System.out.println("=================================================");
        System.out.println(" Server starting at http://localhost:" + port + "/");
        System.out.println(" Default Credentials:");
        System.out.println("   Username: admin   Password: admin123");
        System.out.println("   Username: user    Password: user123");
        System.out.println("=================================================");

        tomcat.start();
        tomcat.getServer().await();
    }
}
