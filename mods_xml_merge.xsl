<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mods="http://www.loc.gov/mods/v3"
    xpath-default-namespace="http://www.loc.gov/mods/v3" exclude-result-prefixes="xs" version="2.0"
    xmlns="http://www.loc.gov/mods/v3">

    <!--   
    This stylesheet merges a directory of MODS XML files into a single MODS XML file 
    with a mods:modsCollection root element.
    -->

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <!-- USER: update the value with the path to the directory where the MODS XML files are located;
            Note that the trailing slash must be present. -->
    <xsl:param name="directoryName">
        <xsl:text>merge_test/</xsl:text>
    </xsl:param>

    <!-- Creates the root modsCollection element and calls XML documents in the named directory -->
    <xsl:template match="/">
        <modsCollection>
            <xsl:apply-templates select="collection($directoryName)//mods"/>
        </modsCollection>
    </xsl:template>

    <!-- Identity transform to copy the contents of each MODS XML file -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Specifically for MODS extracted with Islandora Datastream CRUD;
        Extracts and formats the item PID using the filename of each MODS XML file;
        Adds the PID as an identifier as the first element of the outputted MODS record.
         -->
    <xsl:template match="mods/*[1]">
        <xsl:if test="contains(base-uri(.), '_MODS.xml')">
            <identifier type="local" displayLabel="PID">
                <xsl:value-of
                    select="replace(replace(substring-after(base-uri(.), $directoryName), '_MODS.xml', ''), '_', ':')"
                />
            </identifier>
        </xsl:if>
        <xsl:copy-of select="."/>
    </xsl:template>

</xsl:stylesheet>
