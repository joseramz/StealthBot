<?php
    /** 
    *   Andy Trevino
    *   Project:       hw4
    *   File:          Database.php
    *   Generic database handler class
    *   Adapted for StealthBot New Readme
    */    
    defined("__READMEFILE") or die("Invalid access"); 

    class DBHandler
    {
        var $username;
        var $password;
        var $dbname;
        var $server;
        var $db;
        var $connected;
        
        function DBHandler($serv = "localhost")
        {
            $this->username = "steal5_rmuser";
            $this->password = "r0mp12gz";
            $this->dbname = "steal5_readme";
            $this->server = $serv;
            $this->connected = false;
            
            $this->db = @mysql_connect($this->server, $this->username, $this->password);

            if (!$this->db)
            {
                print("Could not connect to the MySQL server. Error: " . mysql_error());
                return;
            }

            if (!@mysql_select_db($this->dbname, $this->db))
            {
                print("Connection to the MySQL database failed. Error:<BR>\n" . mysql_error());
                return;
            }    
            
            $this->connected = true;
        }  
        
        // Performs the query stored in $query and returns the result object
        function doQuery($query)
        {
            $ret = mysql_query($query, $this->db);    
            if ($ret == false) 
                die ("Error: A problem was encountered while executing this query. $query<br><br>" . mysql_error());
            
            return $ret;
        }
        
        // Sanitizes a string for querying
        function sanitize($str)
        {
            return mysql_escape_string($str);
        }
    }
?>