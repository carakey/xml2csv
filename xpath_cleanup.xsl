<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mods="http://www.loc.gov/mods/v3"
    xpath-default-namespace="http://www.loc.gov/mods/v3" exclude-result-prefixes="xs" version="2.0"
    xmlns="http://www.loc.gov/mods/v3">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="root">
        <root>
            <xsl:for-each select="distinct-values(path)">
                <field>
                    <path>
                        <xsl:value-of select="."/>
                    </path>
                    <header>
                        <xsl:variable name="terminus" select="replace(.,'^.*/','')"/>
                        <xsl:choose>
                            <xsl:when test="contains(.,'roleTerm')">
                                <xsl:value-of select="'roleTerm'"/>
                            </xsl:when>
                            <xsl:when test="contains(.,'displayLabel')">
                                <xsl:value-of select="substring-before(substring-after(.,'displayLabel=&quot;'),'&quot;]')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="replace($terminus,'\[.*','')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </header>
                </field>
            </xsl:for-each>
        </root>
    </xsl:template>
    
</xsl:stylesheet>