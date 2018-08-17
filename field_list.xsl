<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    
    <!-- 
        This stylesheet is meant for use on the output of xpath_list.xsl.
        It identifies the unique XPaths in the collection - that is, where both the elements and attributes are distinct. 
        For each unique path, the stylesheet: 
            1) creates a field name to use as the column header in the CSV; and 
            2) writes the mapping line to convert the updated data back to MODS XML.
    -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- To Do:
        * insert special handling of snowflake fields in this file
            * name: namePart + roleTerm
            * 
        * when the displayLabel element has multiple children...?
        * update follow-on stylesheets for changed element names here 
        * add commentary
    -->
    
    <!-- Creates a list of unique XPaths and store it as a variable; omit certain migration-related data from MODS extension fields -->
    <xsl:variable name="uniquePaths" select="distinct-values(xpathList/xpath[not(contains(.,'@timestamp'))][not(contains(.,'@source'))])"/>
    
    <!-- Builds document structure -->
    <xsl:template match="/">
        <fieldList>
            <!-- Gets a count of total fields -->
            <fieldCount>
                <xsl:value-of select="count($uniquePaths)"/>
            </fieldCount>
            
            <!-- For each unique XPath, copies the XPath adds a fieldName element and a mapping element -->
            <xsl:for-each select="$uniquePaths">
                <field>
                    <xpath>
                        <xsl:value-of select="."/>
                    </xpath>
                    <fieldName>
                        <xsl:call-template name="fieldName"/>
                    </fieldName>
                    <mapping>
                        <xsl:call-template name="mapping"/>
                    </mapping>
                </field>
            </xsl:for-each>
        </fieldList>
    </xsl:template>
    
    <xsl:template name="fieldName">
        <xsl:variable name="terminus" select="replace(., '^.*/', '')"/>
        <xsl:choose>
            <xsl:when test="contains(., 'roleTerm')">
                <xsl:value-of select="'roleTerm'"/>
            </xsl:when>
            <xsl:when test="contains(., 'displayLabel')">
                <xsl:value-of
                    select="substring-before(substring-after(., 'displayLabel=&quot;'), '&quot;]')"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="replace($terminus, '\[.*', '')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="mapping">
        <xsl:variable name="modsTopLevel" select="replace(.,'/modsCollection/mods/','')"/>
        <xsl:for-each select="tokenize($modsTopLevel,'/')">
            <xsl:text>&lt;</xsl:text>
            <xsl:value-of select="replace(replace(.,'\[',' '),'\]','')"/>
            <xsl:text>&gt;</xsl:text>
        </xsl:for-each>
        <xsl:text>%value%</xsl:text>
        <xsl:for-each select="tokenize($modsTopLevel,'/')">
            <xsl:sort select="position()" order="descending"/> 
            <xsl:text>&lt;/</xsl:text>
            <xsl:choose>
                <xsl:when test="contains(.,'[')">
                    <xsl:value-of select="substring-before(.,'[')"/>  
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>&gt;</xsl:text>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>