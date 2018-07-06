<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mods="http://www.loc.gov/mods/v3"
    xpath-default-namespace="http://www.loc.gov/mods/v3" exclude-result-prefixes="xs" version="2.0"
    xmlns="http://www.loc.gov/mods/v3">
    
    <xsl:output method="text"/>
    
    <xsl:param name="fieldList" select="document('headers_test.xml')"/>
        
    <xsl:template match="/">
        <xsl:call-template name="headerRow"/>
        <xsl:apply-templates select="modsCollection/mods"/>
    </xsl:template>
    
    <!-- note to self: not getting dmGetItemInfo (deliberately, for now, but need to address)-->
    
    <!-- Begin header row -->
    <xsl:template name="headerRow">
        <xsl:for-each select="$fieldList//field">
            <xsl:value-of select="header"/>
            <xsl:choose>
                <xsl:when test="position()!=last()">
                    <xsl:text>,</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#xa;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <!-- End header row -->
  
    <xsl:template match="mods">
        <xsl:variable name="record" select="."/>
        <xsl:for-each select="$fieldList//field">
            <xsl:variable name="header" select="header"/>
            <xsl:variable name="labelMatch" select="$record/*[@displayLabel=$header]"/>
            <xsl:variable name="elementMatch" select="$record//*[name()=$header]"/>
            
            <xsl:variable name="value">
                <xsl:choose>
                    <xsl:when test="$header='roleTerm'"/>
                    <xsl:when test="not(contains(./path,'displayLabel'))">
                        <xsl:choose>
                            <xsl:when test="$header='title'">
                                <xsl:for-each select="$record/titleInfo[not(@displayLabel)]/title">
                                    <xsl:value-of select="."/>
                                    <xsl:if test="position()!=last()">
                                        <xsl:text>; </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:for-each select="$elementMatch">
                                    <xsl:value-of select="normalize-space(.)"/>
                                    <xsl:if test="position()!=last()">
                                        <xsl:text>; </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$labelMatch">
                        <xsl:for-each select="normalize-space($labelMatch)">
                        <xsl:value-of select="."/>
                            <xsl:if test="position()!=last()">
                                <xsl:text>; </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            
            <xsl:choose>
                <xsl:when test="contains($value,',')">
                    <xsl:value-of select="concat('&quot;',$value,'&quot;')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$value"/>
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:choose>
                <xsl:when test="position() != last()">
                    <xsl:text>,</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#xa;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>