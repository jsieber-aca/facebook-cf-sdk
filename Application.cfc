﻿component {
	
	this.name = "facebook-cf-sdk-v4";
	this.sessionManagement = true;

	this.mappings["/facebook"]= "/Applications/apache-tomcat-7.0.55/webapps/railo-4.2.1.000/facebook/src";
	this.mappings["/tests"]= "/Applications/apache-tomcat-7.0.55/webapps/railo-4.2.1.000/facebook/tests";
	this.mappings["/testbox"]= "/Applications/apache-tomcat-7.0.55/webapps/railo-4.2.1.000/testbox";

}