# XML to CSV

## Overview

This repository includes several XSLT 2.0 stylesheets which combine to convert metadata records in XML format into a CSV document.

Each unique XPath in the source XML will be represented as a separate column in the resulting CSV document. "Unique" here includes not just element names, but also attribute values.

The use case for which this was first developed was the export of MODS records from Islandora (specifically, the Louisiana Digital Library or LDL) and subsequent presentation of the metadata in spreadsheet format for sharing, editing, etc.

### Notes:  

* Either XML editing/debugging software such as Oxygen or a command-line XSLT processor such as Saxon is required to run the transforms.
* While designed with MODS in mind, the **xpath_list.xsl** stylesheet should work with any well-formed XML document as input, to create a list (in arbitrary XML) of every XPath present in the source document. Note that this is not yet a unique list; the next step, using **field_list.xsl**, isolates the unique XPaths.
* The metadata sets on which this process was tested were exclusively MODS XML records, and the XSLT herein includes MODS artifacts.  
* The MODS metadata sets on which this was tested make heavy use of *displayLabel* attributes to distinguish specific elements, which is in turn reflected in the XSLT.
* The metadata sets on which this was tested were originally migrated to Islandora from CONTENTdm using the [Move to Islandora Kit](https://github.com/MarcusBarnes/mik), and these stylesheets may include remnants and relics of particular data structures from MIK and/or CONTENTdm.

## Applications

* Batch data cleanup  
* Vocabulary reconciliation
* Migration of XML records
* Downloading & sharing collections as data

## Process

General workflow is to:
1. [Export/prepare source XML metadata](#1-prepare-a-single-source-xml-metadata-document)
1. [Create a list all XPaths present in the source document](#2-create-a-list-of-all-xpaths-in-the-metadata)
1. [Create a list of unique fields present in the source document](#3-create-a-list-of-the-unique-fields-present-in-the-metadata)
1. [Create a CSV file by cross-referencing the source metadata document with the field list](#4-create-a-csv-file-of-the-metadata-arranged-using-the-list-of-fields)

### 1. Prepare a single source XML metadata document

The follow-on XSLT stylesheets could have been written to take an arbitrary number of documents; however, having a single source XML file makes QA much more straightforward.

The use case for this process involves the export of metadata records from a digital library using a third party utility. However, there's no reason the later steps wouldn't work with XML from another source -- say, OAI-PMH harvested metadata.

**For exporting MODS XML records from Islandora 7.X**, we recommend [Islandora Datastream CRUD](https://github.com/SFULibrary/islandora_datastream_crud). This utility will produce one MODS XML file per PID.

Merge the multiple MODS XML files into a single "MODS Collection" XML file with a `<mods:modsCollection>` root element using **mods_xml_merge.xsl**.
* _Usage:_ With the location of the XML files as the _directoryName_ parameter and the XSLT file itself as the source, run **mods_xml_merge.xsl** in Oxygen, or at the command line with Saxon:
  * `java -jar saxon9he.jar -s:mods_xml_merge.xsl -xsl:mods_xml_merge.xsl -o:collectionName_mods.xml directoryName=input_directory/`  
  * Because of the 'directoryName' parameter, this must be run from the location of the input directory.  
  * The input directory name is passed in as the 'directoryName' parameter, INCLUDING the trailing slash.  
* This stylesheet also adds an `<identifier>` element to each MODS record, with the item's PID as its value, derived from the MODS XML filename as formatted by the Datastream CRUD output.

![Screenshot of modsCollection document in Oxygen](assets/modsCollection_oxygen.JPG)

### 2. Create a list of all XPaths in the metadata

The **xpath_list.xsl** stylesheet reads a source XML file and outputs an arbitrary XML file listing each XPath in the source as a string. In the resulting document, the distinct-values() function may be used to identify unique XPaths.

_Note that these strings cannot be substituted for expressions in follow-on XSLT 1.0 or 2.0 stylesheets._

* _Usage:_ With the single XML metadata document as the source, run **xpath_list.xsl** in Oxygen, or at the command line with Saxon:
  * `java -jar saxon9he.jar -s:collectionName_mods.xml -xsl:xpath_list.xsl -o:collectionName_xpaths.xml`

![Screenshot of xpath_list output document in Oxygen](assets/xpath_list_output.JPG)

### 3. Create a list of the unique fields present in the metadata

The **field_list.xsl** identifies the unique XPaths in the source metadata - that is, where both the elements and attributes are distinct. For each unique path, the stylesheet creates a field name to use as the column header in the CSV.

_At this point in time, this stylesheet also writes a "mapping" string. Currently, this should be ignored; the intent is that this would be used to create a separate mapping CSV file, as used by the [Move to Islandora Kit CSV to MODS Toolchain](https://github.com/MarcusBarnes/mik/wiki/Toolchain:-CSV-single-file-objects), to convert the CSV data back to XML records after they were updated._

The output of field_list.xsl can be used for numerous QA applications, such as evaluating consistency in the usage of elements and attributes within a set of metadata.

* _Usage:_ With the output of xpath_list.xsl as the source, run **field_list.xsl** in Oxygen, or at the command line with Saxon:
  * `java -jar saxon9he.jar -s:collectionName_xpaths.xml -xsl:field_list.xsl -o:collectionName_fields.xml`

![Screenshot of field_list output document in Oxygen](assets/field_list_output.JPG)

### 4. Create a CSV file of the metadata arranged using the list of fields

The field names from the field list will be the column headers. There will be one row of data per metadata record.

* _Usage:_ With the single XML metadata document as the source, and with the output of field_list.xsl as the _headerFile_ parameter, run **csv_maker.xsl** in Oxygen, or at the command line with Saxon:
  * `java -jar saxon9he.jar -s:collectionName_mods.xml -xsl:csv_maker.xsl -o:collectionName.csv headerFile=collectionName_mods.xml`


## Known Issues & Intended Improvements

* CSV Maker is not working.
* In field_list.xsl:
    * add @type as a modifier for naming fields
    * insert special handling of snowflake fields in this file
        * Example: name/ namePart + roleTerm
    * handle the case where a displayLabel element has multiple children
* Get the distinct values at the XPath List step rather than the Field List step.
* Mapping back from CSV to MODS with MIK is completely untested; the double quotes in attribute values need to be replaced with apostrophes.
* Additional namespace declarations will be needed in header of csv_maker to handle non-MODS
