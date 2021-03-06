<?xml version="1.0" encoding="UTF-8"?>

<#-- Import common macros and functions -->
<#import "macros_common.ftl" as com>
<#import "macros_csr.ftl" as csr>
<#import "macros_pnec.ftl" as pnec>

<!-- DNEL main template file -->
<#assign locale = "en" />
<#assign sysDateTime = .now>

<book version="5.0" xmlns="http://docbook.org/ns/docbook" xmlns:xi="http://www.w3.org/2001/XInclude">

	<#assign left_header_text = ''/> 
	<#assign central_header_text = ''/> 
	<#assign right_header_text = ''/> 
	
	<#assign left_footer_text = sysDateTime?string["dd/MM/yyyy"] + " - IUCLID 6 " + iuclid6Version!/> 
	<#assign central_footer_text = 'PNEC calculator report'/> 
	<#assign right_footer_text = ''/> 

	<#assign substance = rootDocument />
	<#assign ownerLegalEntity = iuclid.getDocumentForKey(rootDocument.OwnerLegalEntity) />
	<#if rootDocument.documentType == 'SUBSTANCE'>
		<#assign referenceSubstance = iuclid.getDocumentForKey(rootDocument.ReferenceSubstance.ReferenceSubstance) />
	<#else>
		<#assign referenceSubstance = '' />
	</#if>

	<info>
        <title>PNEC calculator report</title>
		<cover>
            <para>
				<para>
					<#if rootDocument.documentType == 'SUBSTANCE'>
						<emphasis role="bold">Substance Name:</emphasis> <@com.text rootDocument.ChemicalName />
					<#else>					
						<emphasis role="bold">Template Name:</emphasis> <@com.text rootDocument.TemplateName />
					</#if>
				</para>
				<#if referenceSubstance?has_content>
					<para>		
						<emphasis role="bold">EC Number:</emphasis>
						<@com.inventoryECNumber referenceSubstance.Inventory.InventoryEntry />
					</para>
					<para>
						<emphasis role="bold">CAS Number:</emphasis>
						<#assign casNumberInv>
							<@com.inventoryECCasNumber referenceSubstance.Inventory.InventoryEntry />
						</#assign>
						<#if casNumberInv?has_content>
							${casNumberInv}
						<#else>
							<@com.text referenceSubstance.ReferenceSubstanceInfo.CASInfo.CASNumber />
						</#if>
					</para>
				</#if>	
				<para>
					<emphasis role="bold">Registrant's Identity: </emphasis><#if ownerLegalEntity?has_content><@com.text ownerLegalEntity.GeneralInfo.LegalEntityName/></#if>
				</para>
				<para></para>
				<para>
					<emphasis role="bold">Eco-Toxicological Information Document Name:</emphasis> <@com.text reportingDocument.name />
				</para>				
			</para>
        </cover>
    </info>
    
    <chapter label="1">
    	<title role="HEAD-2">PNEC derivation and other hazard conclusions</title>
    	
    	<para><emphasis role="underline"><@com.text reportingDocument.name/></emphasis></para>
    	
    	<@pnec.generateReport reportingDocument/>
	</chapter>
</book>