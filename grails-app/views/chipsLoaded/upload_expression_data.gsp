<%@ page import="common.chipInfo.ChipsLoaded" %>
<html>
  <head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="chipsLoadedMain" />
    <g:set var="entityName" value="${message(code: 'chipsLoaded.label', default: 'ChipsLoaded')}" />
    <title>Upload Expression Data</title>
  </head>

  <body>

    <div class="chipsloaded-container">
      <div class="matcreate-wrapper">

        <h1>Upload Expression Data</h1>

        <g:if test="${flash.message}">
          <div class="alert-message error message">
            ${flash.message}
          </div>
        </g:if>

        <div id="errorMessageDiv" class="alert-message" style="display:none;">
        </div>

        <div id="uploadingMessageDiv" class="alert-message message"
             style="display:none;">
          Your file is being uploaded. It will be imported into the database later
          (generally overnight).
        </div>
        <div id="importingMessageDiv" class="alert-message message"
             style="display:none;">
          Your file is being uploaded and will be imported now. Depending on the
          size of the dataset this can take a while (as much as an hour).
        </div>

        <div class="centered-gray">
          <g:uploadForm id="uploadForm" action="uploadExpressionData">

            <div id="expressionDataFileDiv" class="section">
              <label for="expressionDataFile">
                Expression data file<span class="required">*</span>
              </label>
              <div class="input">
                <input type="file" name="expressionDataFile"
                       id="expressionDataFile" />
              </div>
            </div>

            <div id="fileTypeDiv" class="section">
              <label for="fileType">
                File type<span class="required">*</span>
              </label>
              <div class="input">
                <select name="fileType" id="fileType">
                </select>
                <a href="${resource( file: 'supported.gsp')}"
                   target="_blank" class="small">Supported file formats</a>
              </div>
            </div>

            <div id="manufacturerDiv" class="section" style="display:none;">
              <label for="manufacturer">
                Manufacturer
              </label>
              <div class="input">
                <select name="manufacturer" id="manufacturer">
                </select>
              </div>
            </div>

            <div id="chipTypeDiv" style="display:none;" class="section">
              <label for="chipType">
                Chip type<span class="required">*</span>
              </label>
              <div class="input">
                <select name="chipType" id="chipType">
                </select>
              </div>
            </div>

            <div id="genomicDataSourceDiv" class="section">
              <label for="genomicDataSource">
                Data Source<span class="required">*</span>
              </label>
              <div class="input">
                <select name="genomicDataSource" id="genomicDataSource">
                </select>
              </div>
            </div>
            
            <div id="emailRecipientDiv" style="padding-top:20px;">
              <label for="emailRecipient" class="section">
                E-mail address
              </label>
              <div class="input">
                <input type="email"  name="emailRecipient" id="emailRecipient" />
              </div>
            </div>

            <p class="required">fields marked with an * are required</p>

            <hr style="border-color: #ddd; margin-top:25px; margin-bottom:0;" />

            <p style="text-align: right; padding-top:10px;" class="small"><a href="#" id="advancedOptionsToggle">View Advanced Options</a></p>

            <div id="advancedOptions" style="display: none;">

                <fieldset id="formatValidationDiv" style="padding-top:0;">

                  <h3>Format validation</h3>

                  <div class="section">
                    <label class="longlabel" for="pValColumnRequired">
                      Detection p-value column required
                    </label>
                    <div class="input forlonglabel" style="padding-top:5px;">
                      <input type="checkbox" name="pValColumnRequired"
                             id="pValColumnRequired" />
                    </div>
                  </div>

                </fieldset>
            
                <fieldset id="dataValidationDiv">
                  <h3>Data validation</h3>

                  <div class="section clearfix">
                    <label class="longlabel" for="requireKnownProbeId">
                      Probe IDs must be listed in chip annotation
                    </label>
                    <div class="input forlonglabel"  style="padding-top:15px;">
                      <input type="checkbox" name="requireKnownProbeId"
                             id="requireKnownProbeId" />
                    </div>
                  </div>

                  <div class="section clearfix">
                    <label class="longlabel" for="requireSignal">
                      Signal values required
                    </label>
                    <div class="input forlonglabel"  style="padding-top:5px;">
                      <input type="checkbox" name="requireSignal"
                             id="requireSignal" />
                    </div>
                  </div>

                  <div class="section clearfix">
                    <label class="longlabel" for="requireDetection">
                      Detection p-values required
                    </label>
                    <div class="input forlonglabel" style="padding-top:5px;">
                      <input type="checkbox" name="requireDetection"
                             id="requireDetection" />
                    </div>
                  </div>

                  <div class="section clearfix">
                    <label class="longlabel" for="requireNegatives">
                      Some negative values required (background-subtracted)
                    </label>
                    <div class="input forlonglabel" style="padding-top:15px;">
                      <input type="checkbox" name="requireNegatives"
                             id="requireNegatives" />
                    </div>
                  </div>

                  <hr style="border-color: #ddd; margin-top:25px;" />

                </fieldset>
            

            
                <div id="importNowDiv" class="section clearfix"
                     style="margin-bottom:20px;">
                  <label for="importNow">
                    Import now <br />
                    (rather than overnight)
                  </label>
                  <div class="input" style="padding-top:10px;">
                    <input type="checkbox" name="importNow" id="importNow" />&nbsp;<span class="required"><b title="uploading now will slow down the system significantly">(not recommended)</b></span>
                  </div>
                </div>

              </div><!--end advanced options-->

            <g:submitButton name="upload" id="upload" value="Upload"
                            class="btn primary large" style="width:150px;" />
            
          </g:uploadForm>

          <g:javascript>

(function( )
 {
     var urlBase = "",
         fileTypes = [],
         fileTypeName = "",
         chipTypes = [],
         chipTypeId = -1,
         manufacturers = [],
         genomicDataSources = [],
         advancedOptionsHidden = true;
     

     function init( )
     {
         urlBase =
             (function( )
              {
                  var curPath = location.pathname;
                  return curPath.substring( 0, curPath.indexOf( "/", 1 ) );
              })();
         $("#expressionDataFile").change( handleUploadFileChange );
         $("#upload").click( handleSubmit );
         $("#uploadForm").submit( handleSubmit );
         $("#advancedOptionsToggle").click( toggleAdvancedOptions );
         queryFileTypes( );
         queryGenomicDataSources( );
     }

     function displayErrorMessage( msg )
     {
         $("#errorMessageDiv").html( msg );
         $("#errorMessageDiv").show( );
     }

     function clearErrorMessage( )
     {
         $("#errorMessageDiv").hide( );
         $("#errorMessageDiv").html( "" );
     }

     
     function addOption( select, txt, val )
     {
         var opt = $("<option/>");
         if ( val === null )
             val = txt;
         opt.text( txt ).attr( "value", val );
         opt.appendTo( select );
     }

     function setCheckboxValue( elem, value )
     {
         if ( value )
         {
             elem.attr( "checked", "checked" );
         }
         else
         {
             elem.removeAttr( "checked" );
         }
     }


     function findFileTypeByName( name )
     {
         var grepRslt = $.grep( fileTypes,
                                function( fileType, i )
                                {
                                    return (fileType.name == name);
                                } );
         if ( grepRslt.length > 0 )
             return grepRslt[ 0 ];
         return null;
     }

     function findChipTypesByManufacturer( manufacturer )
     {
         return $.grep( chipTypes,
                        function( chipType, i )
                        {
                            return (chipType.manufacturer == manufacturer);
                        } );
     }
     
     function findChipTypeById( id )
     {
         var grepRslt = $.grep( chipTypes,
                                function( chipType, i )
                                {
                                    return (chipType.id == id);
                                } );
         if ( grepRslt.length > 0 )
             return grepRslt[ 0 ];
         return null;
     }

     function findGenomicDataSourceByName( name )
     {
         var grepRslt = $.grep( genomicDataSources,
                                function( dataSource, i )
                                {
                                    return (dataSource.name == name);
                                } );
         if ( grepRslt.length > 0 )
             return grepRslt[ 0 ];
         return null;
     }

     
     function queryFileTypes( )
     {
         if ( fileTypes.length > 0 )
             return;
         $.getJSON(
             urlBase + "/chipsLoaded/listFileTypes",
             { },
             processFileTypes
         );
     }

     function processFileTypes( ajaxResponse )
     {
         fileTypes = ajaxResponse;
         displayFileTypes( );
     }

     function displayFileTypes( )
     {
         var sel = $("#fileType");
         sel.empty( );
         addOption( sel, "Select a file type", "" );
         for ( var i = 0, max = fileTypes.length; i < max; ++i )
         {
             var fileType = fileTypes[ i ];
             addOption( sel, fileType.name );
         }
         sel.change( handleFileTypeSelection );
     }

     
     function queryChipTypes( )
     {
         if ( chipTypes.length > 0 )
             return;
         $.getJSON(
             urlBase + "/chipsLoaded/listChipTypes",
             { technology: "Microarray" },
             processChipTypes
         );
     }
     
     function processChipTypes( ajaxResponse )
     {
         chipTypes = ajaxResponse;
         getManufacturers( );
         displayManufacturers( );
         displayChipTypes( );
     }

     function getManufacturers( )
     {
         var i, max,
             manufacturer;
         manufacturers = [];
         for ( i = 0, max = chipTypes.length; i < max; ++i )
         {
             manufacturer = chipTypes[ i ].manufacturer;
             if ( $.inArray( manufacturer, manufacturers ) < 0 )
             {
                 manufacturers.push( manufacturer );
             }
         }
         manufacturers.sort( );
     }
     
     function displayManufacturers( )
     {
         var sel = $("#manufacturer");
         sel.empty( );
         addOption( sel, "Select a manufacturer", "" );
         for ( var i = 0, max = manufacturers.length; i < max; ++i )
         {
             var manufacturer = manufacturers[ i ];
             addOption( sel, manufacturer );
         }
         $("#manufacturerDiv").show( );
         sel.change( handleManufacturerSelection );
     }
     
     function displayChipTypes( manufacturer )
     {
         var sel = $("#chipType");
         sel.empty( );
         addOption( sel, "Select a platform", -1 );
         for ( var i = 0, max = chipTypes.length; i < max; ++i )
         {
             var chipType = chipTypes[ i ];
             if ( (! manufacturer) ||
                  (chipType.manufacturer === manufacturer) )
             {
                 addOption( sel, chipType.name, chipType.id );
             }
         }
         $("#chipTypeDiv").show( );
         sel.change( handleChipTypeSelection );
     }

     function showManufacturers( )
     {
         if ( chipTypes.length === 0 )
         {
             queryChipTypes( );
         }
         else
         {
             $("#manufacturerDiv").show( );
         }
     }

     function hideManufacturers( )
     {
         $("#manufacturerDiv").hide( );
     }
     
     function showChipTypes( )
     {
         $("#chipTypeDiv").show( );
     }

     function hideChipTypes( )
     {
         $("#chipTypeDiv").hide( );
     }


     function queryGenomicDataSources( )
     {
         if ( genomicDataSources.length > 0 )
             return;
         $.getJSON(
             urlBase + "/chipsLoaded/listGenomicDataSources",
             { },
             processGenomicDataSources
         );
     }
     
     function processGenomicDataSources( ajaxResponse )
     {
         genomicDataSources = ajaxResponse;
         displayGenomicDataSources( );
     }

     function displayGenomicDataSources( )
     {
         var sel = $("#genomicDataSource");
         sel.empty( );
         addOption( sel, "Select a source", -1 );
         for ( var i = 0, max = genomicDataSources.length; i < max; ++i )
             {
                 var genomicDataSource = genomicDataSources[ i ];
                 addOption( sel, genomicDataSource.name, genomicDataSource.id );
             }
         sel.change( handleGenomicDataSourceSelection );
     }


     function handleUploadFileChange( )
     {
         clearErrorMessage( );
     }
     
     function handleFileTypeSelection( )
     {
         var fileType;
         clearErrorMessage( );
         fileTypeName = $("#fileType").val();
         if ( fileTypeName === "" )
         {
             hideManufacturers( );
             hideChipTypes( );
             hideValidationFields( );
         }
         else
         {
             fileType = findFileTypeByName( fileTypeName );
             if ( fileType.requiresChipType )
             {
                 showManufacturers( );
             }
             else
             {
                 hideManufacturers( );
                 hideChipTypes( );
                 chipTypeId = -1;
             }
             
             setValidationFields( );
             showValidationFields( );
         }
         setGenomicDataSource( );
     }

     function handleManufacturerSelection( )
     {
         var manufacturer = $("#manufacturer").val();
         clearErrorMessage( );
         displayChipTypes( manufacturer );
     }

     function handleChipTypeSelection( )
     {
         chipTypeId = $("#chipType").val();
         clearErrorMessage( );
         setValidationFields( );
     }

     function handleGenomicDataSourceSelection( )
     {
         clearErrorMessage( );
     }


     function setGenomicDataSource( )
     {
         var fileType,
             dataSource;
         fileType = findFileTypeByName( fileTypeName );
         if ( fileType && fileType.defaultGenomicDataSource )
         {
             dataSource = findGenomicDataSourceByName(
                 fileType.defaultGenomicDataSource );
             $("#genomicDataSource").val( dataSource.id );
         }
         else
         {
             $("#genomicDataSource").val( -1 );
         }
     }
     
     
     function showValidationFields( )
     {
         $("#formatValidationDiv").show( );
         $("#dataValidationDiv").show( );
     }

     function hideValidationFields( )
     {
         $("#formatValidationDiv").hide( );
         $("#dataValidationDiv").hide( );
     }

     function setValidationFields( )
     {
         var fileType,
             chipType;
         
         if ( fileTypeName === "" )
             return;

         fileType = findFileTypeByName( fileTypeName );
         if ( fileType.requiresChipType )
         {
             if ( chipTypeId < 0 )
                 return;
             chipType = findChipTypeById( chipTypeId );
             switch ( fileType.validationLevel )
             {
               case 2:
                 switch ( chipType.validationLevel )
                 {
                   case 2:
                     setCheckboxValue( $("#pValColumnRequired"), true );
                     setCheckboxValue( $("#requireKnownProbeId"), true );
                     setCheckboxValue( $("#requireSignal"), true );
                     setCheckboxValue( $("#requireDetection"), true );
                     setCheckboxValue( $("#requireNegatives"), true );
                     break;
                   case 1:
                     setCheckboxValue( $("#pValColumnRequired"), false );
                     setCheckboxValue( $("#requireKnownProbeId"), true );
                     setCheckboxValue( $("#requireSignal"), true );
                     setCheckboxValue( $("#requireDetection"), false );
                     setCheckboxValue( $("#requireNegatives"), false );
                     break;
                   default:
                     setCheckboxValue( $("#pValColumnRequired"), false );
                     setCheckboxValue( $("#requireKnownProbeId"), false );
                     setCheckboxValue( $("#requireSignal"), false );
                     setCheckboxValue( $("#requireDetection"), false );
                     setCheckboxValue( $("#requireNegatives"), false );
                     break;
                 }
                 break;

               case 1:
                 setCheckboxValue( $("#pValColumnRequired"), false );
                 setCheckboxValue( $("#requireDetection"), false );
                 switch ( chipType.validationLevel )
                 {
                   case 2:
                     setCheckboxValue( $("#requireKnownProbeId"), true );
                     setCheckboxValue( $("#requireSignal"), true );
                     setCheckboxValue( $("#requireNegatives"), true );
                     break;
                   case 1:
                     setCheckboxValue( $("#requireKnownProbeId"), true );
                     setCheckboxValue( $("#requireSignal"), true );
                     setCheckboxValue( $("#requireNegatives"), false );
                     break;
                   default:
                     setCheckboxValue( $("#requireKnownProbeId"), false );
                     setCheckboxValue( $("#requireSignal"), false );
                     setCheckboxValue( $("#requireNegatives"), false );
                     break;
                 }
                 break;

               default:
                 setCheckboxValue( $("#pValColumnRequired"), false );
                 setCheckboxValue( $("#requireKnownProbeId"), false );
                 setCheckboxValue( $("#requireSignal"), false );
                 setCheckboxValue( $("#requireDetection"), false );
                 setCheckboxValue( $("#requireNegatives"), false );
                 break;
             }
         }
         else
         {
             switch ( fileType.validationLevel )
             {
               default:
                 setCheckboxValue( $("#pValColumnRequired"), false );
                 setCheckboxValue( $("#requireKnownProbeId"), false );
                 setCheckboxValue( $("#requireSignal"), false );
                 setCheckboxValue( $("#requireDetection"), false );
                 setCheckboxValue( $("#requireNegatives"), false );
                 break;
             }
         }
     }

     
     function handleSubmit( eventObj )
     {
         var fileType,
             msg;
         clearErrorMessage( );
         if ( $("#expressionDataFile").val() === "" )
         {
             msg = "You need to choose a file to upload";
             displayErrorMessage( msg );
             return false;
         }
         if ( fileTypeName === "" )
         {
             msg = "You need to choose a file type";
             displayErrorMessage( msg );
             return false;
         }
         fileType = findFileTypeByName( fileTypeName );
         if ( fileType.requiresChipType )
         {
             if ( chipTypeId < 0 )
             {
                 msg = "You need to choose a chip type";
                 displayErrorMessage( msg );
                 return false;
             }
         }
         if ( $("#genomicDataSource").val() < 0 )
         {
             msg = "You need to choose a genomic data source";
             displayErrorMessage( msg );
             return false;
         }

         if ( $("#importNow").val() === "on" )
         {
             $("#importingMessageDiv").show( );
         }
         else
         {
             $("#uploadingMessageDiv").show( );
         }
         return true;
     }
     
    function toggleAdvancedOptions( )
    {
        if ( advancedOptionsHidden )
        {
            $("#advancedOptionsToggle").text( "Hide Advanced Options" );
            $("#advancedOptions").show( );
        }
        else
        {
            $("#advancedOptionsToggle").text( "View Advanced Options" );
            $("#advancedOptions").hide( );
        }
        advancedOptionsHidden = ! advancedOptionsHidden;
    }
     
     return {
         init: init
     };
 })().init( );

          </g:javascript>
        </div>
      </div>
    </div>
  </body>
</html>
