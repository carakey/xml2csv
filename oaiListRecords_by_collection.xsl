<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xpath-default-namespace="http://www.openarchives.org/OAI/2.0/"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- 
       This stylesheet takes the result of an OAI "ListSets" request,
       makes a "ListRecord" request per collection given in <setSpec>,
       and saves the results as one XML file of records per collection. 
    -->
    
    <xsl:param name="client" select="'https://cdm16340.contentdm.oclc.org'"/>
    <xsl:param name="metadataPrefix" select="'oai_dc'"/>
    
    <xsl:template match="@* | node()">
        <xsl:apply-templates select="ListSets"/>
    </xsl:template>
    
    <xsl:template match="ListSets">
        <xsl:for-each select="set/setSpec">
            <xsl:variable name="coll" select="."/>
            <xsl:variable name="query">
                <xsl:value-of select="concat($client,'/oai/oai.php?verb=ListRecords&amp;metadataPrefix=',$metadataPrefix,'&amp;set=',$coll)"/>
            </xsl:variable>
            <xsl:result-document href="{$coll}-{$metadataPrefix}.xml" method="xml">
                <xsl:copy-of select="document($query)"/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>