<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:bullseye="https://www.bullseye.com/covxml">

<xsl:template match="/">
	<html lang="en">
	<head>
	<title>BullseyeCoverage Sample XML Style Sheet</title>
	<style>
		body	{ font-family:Verdana; font-size:small }
		table	{ border-collapse:collapse }
		th		{ background-color:#e0e0e0; padding:0.2em; text-align:left }
		td		{ padding:0.2em }
		#high	{ background-color:#ffffff }
		#mid	{ background-color:#fff050 }
		#low	{ background-color:#ff5050 }
	</style>
	</head>
	<body>
	<table border="1">
	<tr>
	<th>Name</th>
	<th>Function Coverage</th>
	<th>Condition/Decision</th>
	</tr>
	<xsl:apply-templates/>
	</table>
	</body>
	</html>
</xsl:template>

<xsl:template match="bullseye:src">
	<!-- Name -->
	<tr><td><xsl:value-of select="@name"/></td>
	<!-- Function coverage -->
	<xsl:if test="@fn_total &gt; 0">
		<xsl:choose>
			<xsl:when test="floor(@fn_cov div @fn_total * 100) &lt; 40">
				<td id="low"><xsl:value-of select="floor(@fn_cov div @fn_total * 100)"/>%</td>
			</xsl:when>
			<xsl:when test="floor(@fn_cov div @fn_total * 100) &lt; 80">
				<td id="mid"><xsl:value-of select="floor(@fn_cov div @fn_total * 100)"/>%</td>
			</xsl:when>
			<xsl:otherwise>
				<td id="high"><xsl:value-of select="floor(@fn_cov div @fn_total * 100)"/>%</td>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
	<!-- Condition/decision coverage -->
	<xsl:if test="@cd_total &gt; 0">
		<xsl:choose>
			<xsl:when test="floor(@cd_cov div @cd_total * 100) &lt; 40">
				<td id="low"><xsl:value-of select="floor(@cd_cov div @cd_total * 100)"/>%</td>
			</xsl:when>
			<xsl:when test="floor(@cd_cov div @cd_total * 100) &lt; 80">
				<td id="mid"><xsl:value-of select="floor(@cd_cov div @cd_total * 100)"/>%</td>
			</xsl:when>
			<xsl:otherwise>
				<td id="high"><xsl:value-of select="floor(@cd_cov div @cd_total * 100)"/>%</td>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
	</tr>
	<xsl:apply-templates/>
</xsl:template>
</xsl:stylesheet>
