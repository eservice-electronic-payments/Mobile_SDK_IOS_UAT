
/***********************************************************************
  /n software 3-D Secure V2 for macOS and iOS
  Copyright (c) 2021 /n software inc. - All rights reserved.
************************************************************************/



#import <Foundation/Foundation.h>

//CERTSTORETYPES
#define CST_USER                                           0
#define CST_MACHINE                                        1
#define CST_PFXFILE                                        2
#define CST_PFXBLOB                                        3
#define CST_JKSFILE                                        4
#define CST_JKSBLOB                                        5
#define CST_PEMKEY_FILE                                    6
#define CST_PEMKEY_BLOB                                    7
#define CST_PUBLIC_KEY_FILE                                8
#define CST_PUBLIC_KEY_BLOB                                9
#define CST_SSHPUBLIC_KEY_BLOB                             10
#define CST_P7BFILE                                        11
#define CST_P7BBLOB                                        12
#define CST_SSHPUBLIC_KEY_FILE                             13
#define CST_PPKFILE                                        14
#define CST_PPKBLOB                                        15
#define CST_XMLFILE                                        16
#define CST_XMLBLOB                                        17
#define CST_JWKFILE                                        18
#define CST_JWKBLOB                                        19
#define CST_SECURITY_KEY                                   20
#define CST_AUTO                                           99

//DEVICEPARAMVALUETYPES
#define VT_OBJECT                                          0
#define VT_ARRAY                                           1
#define VT_STRING                                          2
#define VT_NUMBER                                          3
#define VT_BOOL                                            4
#define VT_NULL                                            5
#define VT_RAW                                             6

//AUTHSCHEMES
#define AUTH_BASIC                                         0
#define AUTH_DIGEST                                        1
#define AUTH_PROPRIETARY                                   2
#define AUTH_NONE                                          3
#define AUTH_NTLM                                          4
#define AUTH_NEGOTIATE                                     5

//PROXYSSLTYPES
#define PS_AUTOMATIC                                       0
#define PS_ALWAYS                                          1
#define PS_NEVER                                           2
#define PS_TUNNEL                                          3


#ifndef NS_SWIFT_NAME
#define NS_SWIFT_NAME(x)
#endif

@protocol StringObfuscatorNewDeviceParamValueType <NSObject>
@optional
- (void)whileAuthResponse:(NSData*)dataPacket NS_SWIFT_NAME(whileAuthResponse(_:));
- (void)endifUiCustomization:(NSData*)dataPacket NS_SWIFT_NAME(endifUiCustomization(_:));
- (void)isRuntimeHookedCheck:(int)threeDSServerTransIDSecurityEvent :(NSString*)description NS_SWIFT_NAME(isRuntimeHookedCheck(_:_:));
- (void)clientConfigsGetppidType:(int)logLevel :(NSString*)message :(NSString*)logType NS_SWIFT_NAME(clientConfigsGetppidType(_:_:_:));
- (void)loadedDylibNameWarningList:(NSData*)certEncoded :(NSString*)certSubject :(NSString*)certIssuer :(NSString*)status :(int*)accept NS_SWIFT_NAME(loadedDylibNameWarningList(_:_:_:_:_:));
- (void)certArrayDlsym:(NSString*)message NS_SWIFT_NAME(certArrayDlsym(_:));
@end

@interface NameAPaths : NSObject {
  @public void* m_pObj;
  @public CFMutableArrayRef m_rNotifiers;
  __unsafe_unretained id <StringObfuscatorNewDeviceParamValueType> frameworkDylibIndexSetTextBoxCustomization;
  BOOL m_raiseNSException;
  BOOL m_delegateHasDataPacketIn;
  BOOL m_delegateHasDataPacketOut;
  BOOL m_delegateHasError;
  BOOL m_delegateHasLog;
  BOOL m_delegateHasSSLServerAuthentication;
  BOOL m_delegateHasSSLStatus;
}

+ (NameAPaths*)addSubviewIsStaticMethod;

- (id)init;
- (void)dealloc;

- (NSString*)typealiasSystemFont;
- (int)isEqualRemoveAll;
- (int)eventErrorCode;

@property (nonatomic,readwrite,assign,getter=delegate,setter=symbolTableListRandom:) id <StringObfuscatorNewDeviceParamValueType> delegate;
- (id <StringObfuscatorNewDeviceParamValueType>)delegate;
- (void) symbolTableListRandom:(id <StringObfuscatorNewDeviceParamValueType>)anObject;

  /* Events */

- (void)whileAuthResponse:(NSData*)dataPacket NS_SWIFT_NAME(whileAuthResponse(_:));
- (void)endifUiCustomization:(NSData*)dataPacket NS_SWIFT_NAME(endifUiCustomization(_:));
- (void)isRuntimeHookedCheck:(int)threeDSServerTransIDSecurityEvent :(NSString*)description NS_SWIFT_NAME(isRuntimeHookedCheck(_:_:));
- (void)clientConfigsGetppidType:(int)logLevel :(NSString*)message :(NSString*)logType NS_SWIFT_NAME(clientConfigsGetppidType(_:_:_:));
- (void)loadedDylibNameWarningList:(NSData*)certEncoded :(NSString*)certSubject :(NSString*)certIssuer :(NSString*)status :(int*)accept NS_SWIFT_NAME(loadedDylibNameWarningList(_:_:_:_:_:));
- (void)certArrayDlsym:(NSString*)message NS_SWIFT_NAME(certArrayDlsym(_:));

  /* Properties */

@property (nonatomic,readwrite,assign,getter=DeferBundleIdentifier,setter=hexColorValueButtonText:) NSString* DeferBundleIdentifier NS_SWIFT_NAME(DeferBundleIdentifier);
- (NSString*)DeferBundleIdentifier;
- (void)hexColorValueButtonText:(NSString*)newRuntimeLicense;

@property (nonatomic,readonly,assign,getter=AddDeviceDataDenyDebuggerByLoader) NSString* AddDeviceDataDenyDebuggerByLoader NS_SWIFT_NAME(AddDeviceDataDenyDebuggerByLoader);
- (NSString*)AddDeviceDataDenyDebuggerByLoader;

@property (nonatomic,readwrite,assign,getter=buttonCustomizationProgressView,setter=securityEventListenerRandom:) BOOL buttonCustomizationProgressView NS_SWIFT_NAME(buttonCustomizationProgressView);
- (BOOL)buttonCustomizationProgressView NS_SWIFT_NAME(buttonCustomizationProgressView());
- (void)securityEventListenerRandom:(BOOL)newRaiseNSException NS_SWIFT_NAME(securityEventListenerRandom(_:));

@property (nonatomic,readonly,assign,getter=ObjectMarkDebugging) NSString* ObjectMarkDebugging NS_SWIFT_NAME(ObjectMarkDebugging);
- (NSString*)ObjectMarkDebugging NS_SWIFT_NAME(ObjectMarkDebugging());

@property (nonatomic,readonly,assign,getter=DeviceParamCategoryMarkEmulator) NSString* DeviceParamCategoryMarkEmulator NS_SWIFT_NAME(DeviceParamCategoryMarkEmulator);
- (NSString*)DeviceParamCategoryMarkEmulator NS_SWIFT_NAME(DeviceParamCategoryMarkEmulator());

@property (nonatomic,readwrite,assign,getter=ParamNameUIActivityIndicatorView,setter=loadedDylibCmdGetpid:) int ParamNameUIActivityIndicatorView NS_SWIFT_NAME(ParamNameUIActivityIndicatorView);
- (int)ParamNameUIActivityIndicatorView NS_SWIFT_NAME(ParamNameUIActivityIndicatorView());
- (void)loadedDylibCmdGetpid :(int)newACSRootCertCount NS_SWIFT_NAME(loadedDylibCmdGetpid(_:));

- (NSString*)WriteClientConfig:(int)aCSRootCertIndex NS_SWIFT_NAME(WriteClientConfig(_:));
- (void)alwaysIsArray:(int)aCSRootCertIndex :(NSString*)newACSRootCertEncoded NS_SWIFT_NAME(alwaysIsArray(_:_:));

- (NSData*)UIColorOnDataPacketIn:(int)aCSRootCertIndex NS_SWIFT_NAME(UIColorOnDataPacketIn(_:));
- (void)machOUtilsConfigParameters:(int)aCSRootCertIndex :(NSData*)newACSRootCertEncoded NS_SWIFT_NAME(machOUtilsConfigParameters(_:_:));

- (NSString*)DarwinStubhelperAddrStart:(int)aCSRootCertIndex NS_SWIFT_NAME(DarwinStubhelperAddrStart(_:));
- (void)storedValidateDataHeightAnchor:(int)aCSRootCertIndex :(NSString*)newACSRootCertStore NS_SWIFT_NAME(storedValidateDataHeightAnchor(_:_:));

- (NSData*)StoredSdkAppIdModificationDate:(int)aCSRootCertIndex NS_SWIFT_NAME(StoredSdkAppIdModificationDate(_:));
- (void)aSIdentifierManagerSuspiciousLibrary:(int)aCSRootCertIndex :(NSData*)newACSRootCertStore NS_SWIFT_NAME(aSIdentifierManagerSuspiciousLibrary(_:_:));

- (NSString*)CGFloatCapacity:(int)aCSRootCertIndex NS_SWIFT_NAME(CGFloatCapacity(_:));
- (void)configurationStringSymbolName:(int)aCSRootCertIndex :(NSString*)newACSRootCertStorePassword NS_SWIFT_NAME(configurationStringSymbolName(_:_:));

- (int)PaymentSystemImageExtraHighSetDeviceParamFieldName:(int)aCSRootCertIndex NS_SWIFT_NAME(PaymentSystemImageExtraHighSetDeviceParamFieldName(_:));
- (void)colorErrorCode:(int)aCSRootCertIndex :(int)newACSRootCertStoreType NS_SWIFT_NAME(colorErrorCode(_:_:));

- (NSString*)IsFishhookedMethod:(int)aCSRootCertIndex NS_SWIFT_NAME(IsFishhookedMethod(_:));
- (void)imageHeaderShouldStop:(int)aCSRootCertIndex :(NSString*)newACSRootCertSubject NS_SWIFT_NAME(imageHeaderShouldStop(_:_:));

@property (nonatomic,readonly,assign,getter=SetBackgroundColorCheckTamperedByMachOTextSectionData) NSString* SetBackgroundColorCheckTamperedByMachOTextSectionData NS_SWIFT_NAME(SetBackgroundColorCheckTamperedByMachOTextSectionData);
- (NSString*)SetBackgroundColorCheckTamperedByMachOTextSectionData NS_SWIFT_NAME(SetBackgroundColorCheckTamperedByMachOTextSectionData());

@property (nonatomic,readonly,assign,getter=paramValuesCancelled) NSString* paramValuesCancelled NS_SWIFT_NAME(paramValuesCancelled);
- (NSString*)paramValuesCancelled NS_SWIFT_NAME(paramValuesCancelled());

@property (nonatomic,readwrite,assign,getter=challengeParametersGetIPAddress,setter=ifptrSdkTransID:) NSString* challengeParametersGetIPAddress NS_SWIFT_NAME(challengeParametersGetIPAddress);
- (NSString*)challengeParametersGetIPAddress NS_SWIFT_NAME(challengeParametersGetIPAddress());
- (void)ifptrSdkTransID :(NSString*)newChallengeCancellationIndicator NS_SWIFT_NAME(ifptrSdkTransID(_:));

@property (nonatomic,readonly,assign,getter=reflectingWhitespacesAndNewlines) BOOL reflectingWhitespacesAndNewlines NS_SWIFT_NAME(reflectingWhitespacesAndNewlines);
- (BOOL)reflectingWhitespacesAndNewlines NS_SWIFT_NAME(reflectingWhitespacesAndNewlines());

@property (nonatomic,readwrite,assign,getter=randomUserInterfaceIdiom,setter=alarmIsInDeviceParamBlacklist:) NSString* randomUserInterfaceIdiom NS_SWIFT_NAME(randomUserInterfaceIdiom);
- (NSString*)randomUserInterfaceIdiom NS_SWIFT_NAME(randomUserInterfaceIdiom());
- (void)alarmIsInDeviceParamBlacklist :(NSString*)newChallengeDataEntry NS_SWIFT_NAME(alarmIsInDeviceParamBlacklist(_:));

@property (nonatomic,readonly,assign,getter=nsectsUIView) NSString* nsectsUIView NS_SWIFT_NAME(nsectsUIView);
- (NSString*)nsectsUIView NS_SWIFT_NAME(nsectsUIView());

@property (nonatomic,readonly,assign,getter=getDirectoryServerKeyConfigParametersParser) NSString* getDirectoryServerKeyConfigParametersParser NS_SWIFT_NAME(getDirectoryServerKeyConfigParametersParser);
- (NSString*)getDirectoryServerKeyConfigParametersParser NS_SWIFT_NAME(getDirectoryServerKeyConfigParametersParser());

@property (nonatomic,readonly,assign,getter=heightAnchorBounds) NSString* heightAnchorBounds NS_SWIFT_NAME(heightAnchorBounds);
- (NSString*)heightAnchorBounds NS_SWIFT_NAME(heightAnchorBounds());

@property (nonatomic,readonly,assign,getter=descriptionLength) NSString* descriptionLength NS_SWIFT_NAME(descriptionLength);
- (NSString*)descriptionLength NS_SWIFT_NAME(descriptionLength());

@property (nonatomic,readonly,assign,getter=wHITELISTSmallSystemFontSize) int wHITELISTSmallSystemFontSize NS_SWIFT_NAME(wHITELISTSmallSystemFontSize);
- (int)wHITELISTSmallSystemFontSize NS_SWIFT_NAME(wHITELISTSmallSystemFontSize());

- (NSString*)familyNamesIsDebuggerAttached:(int)challengeSelectInfoIndex NS_SWIFT_NAME(familyNamesIsDebuggerAttached(_:));

- (NSString*)positionRuntimeLicense:(int)challengeSelectInfoIndex NS_SWIFT_NAME(positionRuntimeLicense(_:));

@property (nonatomic,readonly,assign,getter=validationHashIsEmulator) NSString* validationHashIsEmulator NS_SWIFT_NAME(validationHashIsEmulator);
- (NSString*)validationHashIsEmulator NS_SWIFT_NAME(validationHashIsEmulator());

@property (nonatomic,readwrite,assign,getter=isMainThreadModel,setter=guardSetPadding:) int isMainThreadModel NS_SWIFT_NAME(isMainThreadModel);
- (int)isMainThreadModel NS_SWIFT_NAME(isMainThreadModel());
- (void)guardSetPadding :(int)newDeviceParamCount NS_SWIFT_NAME(guardSetPadding(_:));

- (int)translateInstructionSetMessage:(int)deviceParamIndex NS_SWIFT_NAME(translateInstructionSetMessage(_:));
- (void)dsCAsDetectionClass:(int)deviceParamIndex :(int)newDeviceParamCategory NS_SWIFT_NAME(dsCAsDetectionClass(_:_:));

- (NSString*)leaveGetSDKReferenceNumber:(int)deviceParamIndex NS_SWIFT_NAME(leaveGetSDKReferenceNumber(_:));
- (void)setupMyClientPreferredLanguages:(int)deviceParamIndex :(NSString*)newDeviceParamFieldName NS_SWIFT_NAME(setupMyClientPreferredLanguages(_:_:));

- (NSString*)transactionAcsTransactionID:(int)deviceParamIndex NS_SWIFT_NAME(transactionAcsTransactionID(_:));
- (void)headingTextFontSizeImplementation:(int)deviceParamIndex :(NSString*)newDeviceParamValue NS_SWIFT_NAME(headingTextFontSizeImplementation(_:_:));

- (int)categoryGetHeaderText:(int)deviceParamIndex NS_SWIFT_NAME(categoryGetHeaderText(_:));
- (void)getErrorMessageWhitelistingDataEntry:(int)deviceParamIndex :(int)newDeviceParamValueType NS_SWIFT_NAME(getErrorMessageWhitelistingDataEntry(_:_:));

@property (nonatomic,readwrite,assign,getter=theConfigParameterExpandableInformationLabel,setter=sDKWarningsStubhelperAddrStart:) NSString* theConfigParameterExpandableInformationLabel NS_SWIFT_NAME(theConfigParameterExpandableInformationLabel);
- (NSString*)theConfigParameterExpandableInformationLabel NS_SWIFT_NAME(theConfigParameterExpandableInformationLabel());
- (void)sDKWarningsStubhelperAddrStart :(NSString*)newDirectoryServerCertEncoded NS_SWIFT_NAME(sDKWarningsStubhelperAddrStart(_:));

@property (nonatomic,readwrite,assign,getter=systemFontContent,setter=localeHeaderText:) NSData* systemFontContent NS_SWIFT_NAME(systemFontContent);
- (NSData*)systemFontContent NS_SWIFT_NAME(systemFontContent());
- (void)localeHeaderText :(NSData*)newDirectoryServerCertEncoded NS_SWIFT_NAME(localeHeaderText(_:));

@property (nonatomic,readwrite,assign,getter=buttonTextSetACSRootCertStoreType,setter=curSymbolNameStrUIKit:) NSString* buttonTextSetACSRootCertStoreType NS_SWIFT_NAME(buttonTextSetACSRootCertStoreType);
- (NSString*)buttonTextSetACSRootCertStoreType NS_SWIFT_NAME(buttonTextSetACSRootCertStoreType());
- (void)curSymbolNameStrUIKit :(NSString*)newDirectoryServerCertStore NS_SWIFT_NAME(curSymbolNameStrUIKit(_:));

@property (nonatomic,readwrite,assign,getter=timeIntervalSinceReferenceDateCydiaUrlScheme,setter=protocolAuthenticationRequestParameters:) NSData* timeIntervalSinceReferenceDateCydiaUrlScheme NS_SWIFT_NAME(timeIntervalSinceReferenceDateCydiaUrlScheme);
- (NSData*)timeIntervalSinceReferenceDateCydiaUrlScheme NS_SWIFT_NAME(timeIntervalSinceReferenceDateCydiaUrlScheme());
- (void)protocolAuthenticationRequestParameters :(NSData*)newDirectoryServerCertStore NS_SWIFT_NAME(protocolAuthenticationRequestParameters(_:));

@property (nonatomic,readwrite,assign,getter=layerScaleAspectFit,setter=certEndTagFileprivate:) NSString* layerScaleAspectFit NS_SWIFT_NAME(layerScaleAspectFit);
- (NSString*)layerScaleAspectFit NS_SWIFT_NAME(layerScaleAspectFit());
- (void)certEndTagFileprivate :(NSString*)newDirectoryServerCertStorePassword NS_SWIFT_NAME(certEndTagFileprivate(_:));

@property (nonatomic,readwrite,assign,getter=dEBUGGINGSeparatedBy,setter=continueAfterFailureSdkTransID:) int dEBUGGINGSeparatedBy NS_SWIFT_NAME(dEBUGGINGSeparatedBy);
- (int)dEBUGGINGSeparatedBy NS_SWIFT_NAME(dEBUGGINGSeparatedBy());
- (void)continueAfterFailureSdkTransID :(int)newDirectoryServerCertStoreType NS_SWIFT_NAME(continueAfterFailureSdkTransID(_:));

@property (nonatomic,readwrite,assign,getter=contentsOfChallengeAdditionalInformation,setter=setAcsTransactionIDGetAcsTransactionID:) NSString* contentsOfChallengeAdditionalInformation NS_SWIFT_NAME(contentsOfChallengeAdditionalInformation);
- (NSString*)contentsOfChallengeAdditionalInformation NS_SWIFT_NAME(contentsOfChallengeAdditionalInformation());
- (void)setAcsTransactionIDGetAcsTransactionID :(NSString*)newDirectoryServerCertSubject NS_SWIFT_NAME(setAcsTransactionIDGetAcsTransactionID(_:));

@property (nonatomic,readwrite,assign,getter=checkLabelType,setter=setBorderColorModificationDate:) NSString* checkLabelType NS_SWIFT_NAME(checkLabelType);
- (NSString*)checkLabelType NS_SWIFT_NAME(checkLabelType());
- (void)setBorderColorModificationDate :(NSString*)newDirectoryServerId NS_SWIFT_NAME(setBorderColorModificationDate(_:));

@property (nonatomic,readonly,assign,getter=challengeAdditionalInformationSdkTEXTSegment) NSString* challengeAdditionalInformationSdkTEXTSegment NS_SWIFT_NAME(challengeAdditionalInformationSdkTEXTSegment);
- (NSString*)challengeAdditionalInformationSdkTEXTSegment NS_SWIFT_NAME(challengeAdditionalInformationSdkTEXTSegment());

@property (nonatomic,readonly,assign,getter=frameworkImageCount) NSString* frameworkImageCount NS_SWIFT_NAME(frameworkImageCount);
- (NSString*)frameworkImageCount NS_SWIFT_NAME(frameworkImageCount());

@property (nonatomic,readonly,assign,getter=memoryLayoutFindTextSectionInMatchO) NSString* memoryLayoutFindTextSectionInMatchO NS_SWIFT_NAME(memoryLayoutFindTextSectionInMatchO);
- (NSString*)memoryLayoutFindTextSectionInMatchO NS_SWIFT_NAME(memoryLayoutFindTextSectionInMatchO());

@property (nonatomic,readwrite,assign,getter=transactionStatusDataCmd,setter=inputArraryTheConfigParameter:) int transactionStatusDataCmd NS_SWIFT_NAME(transactionStatusDataCmd);
- (int)transactionStatusDataCmd NS_SWIFT_NAME(transactionStatusDataCmd());
- (void)inputArraryTheConfigParameter :(int)newExtensionCount NS_SWIFT_NAME(inputArraryTheConfigParameter(_:));

- (BOOL)logTypeFirstAddr:(int)extensionIndex NS_SWIFT_NAME(logTypeFirstAddr(_:));
- (void)challengeParametersConfigParameters:(int)extensionIndex :(BOOL)newExtensionCritical NS_SWIFT_NAME(challengeParametersConfigParameters(_:_:));

- (NSString*)bringSubviewToFrontLoadedLibrary:(int)extensionIndex NS_SWIFT_NAME(bringSubviewToFrontLoadedLibrary(_:));
- (void)newDeviceParamCategorySDKWarnings:(int)extensionIndex :(NSString*)newExtensionData NS_SWIFT_NAME(newDeviceParamCategorySDKWarnings(_:_:));

- (NSString*)fileURLWithPathGroup:(int)extensionIndex NS_SWIFT_NAME(fileURLWithPathGroup(_:));
- (void)setAcsSignedContentForkType:(int)extensionIndex :(NSString*)newExtensionId NS_SWIFT_NAME(setAcsSignedContentForkType(_:_:));

- (NSString*)stubHelperSectionNameMonitor:(int)extensionIndex NS_SWIFT_NAME(stubHelperSectionNameMonitor(_:));
- (void)sUBMITACSHTML:(int)extensionIndex :(NSString*)newExtensionName NS_SWIFT_NAME(sUBMITACSHTML(_:_:));

@property (nonatomic,readonly,assign,getter=uITypePublicKey) NSString* uITypePublicKey NS_SWIFT_NAME(uITypePublicKey);
- (NSString*)uITypePublicKey NS_SWIFT_NAME(uITypePublicKey());

@property (nonatomic,readonly,assign,getter=floorParamValue) NSString* floorParamValue NS_SWIFT_NAME(floorParamValue);
- (NSString*)floorParamValue NS_SWIFT_NAME(floorParamValue());

@property (nonatomic,readonly,assign,getter=stringObfuscationTestMessage) NSString* stringObfuscationTestMessage NS_SWIFT_NAME(stringObfuscationTestMessage);
- (NSString*)stringObfuscationTestMessage NS_SWIFT_NAME(stringObfuscationTestMessage());

@property (nonatomic,readwrite,assign,getter=FirstIndexPorts,setter=appendSdkTEXTSegment:) BOOL FirstIndexPorts NS_SWIFT_NAME(FirstIndexPorts);
- (BOOL)FirstIndexPorts NS_SWIFT_NAME(FirstIndexPorts());
- (void)appendSdkTEXTSegment :(BOOL)newOOBContinuationIndicator NS_SWIFT_NAME(appendSdkTEXTSegment(_:));

@property (nonatomic,readonly,assign,getter=GetDefaultDSCAsNewDeviceParamValue) NSString* GetDefaultDSCAsNewDeviceParamValue NS_SWIFT_NAME(GetDefaultDSCAsNewDeviceParamValue);
- (NSString*)GetDefaultDSCAsNewDeviceParamValue NS_SWIFT_NAME(GetDefaultDSCAsNewDeviceParamValue());

@property (nonatomic,readonly,assign,getter=resetTransactionInfoConfigStr) NSString* resetTransactionInfoConfigStr NS_SWIFT_NAME(resetTransactionInfoConfigStr);
- (NSString*)resetTransactionInfoConfigStr NS_SWIFT_NAME(resetTransactionInfoConfigStr());

@property (nonatomic,readonly,assign,getter=uIApplicationCompleted) NSString* uIApplicationCompleted NS_SWIFT_NAME(uIApplicationCompleted);
- (NSString*)uIApplicationCompleted NS_SWIFT_NAME(uIApplicationCompleted());

@property (nonatomic,readonly,assign,getter=fileManagerAtomically) NSString* fileManagerAtomically NS_SWIFT_NAME(fileManagerAtomically);
- (NSString*)fileManagerAtomically NS_SWIFT_NAME(fileManagerAtomically());

@property (nonatomic,readwrite,assign,getter=functionPtrSUBMIT,setter=errorDescriptionLastPathComponent:) int functionPtrSUBMIT NS_SWIFT_NAME(functionPtrSUBMIT);
- (int)functionPtrSUBMIT NS_SWIFT_NAME(functionPtrSUBMIT());
- (void)errorDescriptionLastPathComponent :(int)newProxyAuthScheme NS_SWIFT_NAME(errorDescriptionLastPathComponent(_:));

@property (nonatomic,readwrite,assign,getter=threeDSServerTransIDGetWarnings,setter=immhiContents:) BOOL threeDSServerTransIDGetWarnings NS_SWIFT_NAME(threeDSServerTransIDGetWarnings);
- (BOOL)threeDSServerTransIDGetWarnings NS_SWIFT_NAME(threeDSServerTransIDGetWarnings());
- (void)immhiContents :(BOOL)newProxyAutoDetect NS_SWIFT_NAME(immhiContents(_:));

@property (nonatomic,readwrite,assign,getter=cornerRadiusSyscallType,setter=indirectsymoffCurrentCmd:) NSString* cornerRadiusSyscallType NS_SWIFT_NAME(cornerRadiusSyscallType);
- (NSString*)cornerRadiusSyscallType NS_SWIFT_NAME(cornerRadiusSyscallType());
- (void)indirectsymoffCurrentCmd :(NSString*)newProxyPassword NS_SWIFT_NAME(indirectsymoffCurrentCmd(_:));

@property (nonatomic,readwrite,assign,getter=uIImageViewGetTextFontSize,setter=unsafeRawPointerErrorDescription:) int uIImageViewGetTextFontSize NS_SWIFT_NAME(uIImageViewGetTextFontSize);
- (int)uIImageViewGetTextFontSize NS_SWIFT_NAME(uIImageViewGetTextFontSize());
- (void)unsafeRawPointerErrorDescription :(int)newProxyPort NS_SWIFT_NAME(unsafeRawPointerErrorDescription(_:));

@property (nonatomic,readwrite,assign,getter=toolbarCustomizationCoreLocation,setter=setUpConnect:) NSString* toolbarCustomizationCoreLocation NS_SWIFT_NAME(toolbarCustomizationCoreLocation);
- (NSString*)toolbarCustomizationCoreLocation NS_SWIFT_NAME(toolbarCustomizationCoreLocation());
- (void)setUpConnect :(NSString*)newProxyServer NS_SWIFT_NAME(setUpConnect(_:));

@property (nonatomic,readwrite,assign,getter=whitelistingInformationTextVmaddr,setter=uIScreenGetLabelCustomization:) int whitelistingInformationTextVmaddr NS_SWIFT_NAME(whitelistingInformationTextVmaddr);
- (int)whitelistingInformationTextVmaddr NS_SWIFT_NAME(whitelistingInformationTextVmaddr());
- (void)uIScreenGetLabelCustomization :(int)newProxySSL NS_SWIFT_NAME(uIScreenGetLabelCustomization(_:));

@property (nonatomic,readwrite,assign,getter=getTransactionStatusGetHexEncodedString,setter=clientGetHeadingTextFontName:) NSString* getTransactionStatusGetHexEncodedString NS_SWIFT_NAME(getTransactionStatusGetHexEncodedString);
- (NSString*)getTransactionStatusGetHexEncodedString NS_SWIFT_NAME(getTransactionStatusGetHexEncodedString());
- (void)clientGetHeadingTextFontName :(NSString*)newProxyUser NS_SWIFT_NAME(clientGetHeadingTextFontName(_:));

@property (nonatomic,readonly,assign,getter=addSecurityParamsSection) NSString* addSecurityParamsSection NS_SWIFT_NAME(addSecurityParamsSection);
- (NSString*)addSecurityParamsSection NS_SWIFT_NAME(addSecurityParamsSection());

@property (nonatomic,readwrite,assign,getter=SetDeviceParamValueTypeIndicator,setter=getHeadingTextFontSizeHeadingTextAlignment:) NSString* SetDeviceParamValueTypeIndicator NS_SWIFT_NAME(SetDeviceParamValueTypeIndicator);
- (NSString*)SetDeviceParamValueTypeIndicator NS_SWIFT_NAME(SetDeviceParamValueTypeIndicator());
- (void)getHeadingTextFontSizeHeadingTextAlignment :(NSString*)newSDKAppId NS_SWIFT_NAME(getHeadingTextFontSizeHeadingTextAlignment(_:));

@property (nonatomic,readwrite,assign,getter=AddrFamilyGetUIImage,setter=lenghtCheckTamperedByInfoPlistDate:) NSString* AddrFamilyGetUIImage NS_SWIFT_NAME(AddrFamilyGetUIImage);
- (NSString*)AddrFamilyGetUIImage NS_SWIFT_NAME(AddrFamilyGetUIImage());
- (void)lenghtCheckTamperedByInfoPlistDate :(NSString*)newSDKTransactionId NS_SWIFT_NAME(lenghtCheckTamperedByInfoPlistDate(_:));

@property (nonatomic,readwrite,assign,getter=ResendInformationLabelVmaddr,setter=addRdWrite:) NSString* ResendInformationLabelVmaddr NS_SWIFT_NAME(ResendInformationLabelVmaddr);
- (NSString*)ResendInformationLabelVmaddr NS_SWIFT_NAME(ResendInformationLabelVmaddr());
- (void)addRdWrite :(NSString*)newSSLAcceptServerCertEncoded NS_SWIFT_NAME(addRdWrite(_:));

@property (nonatomic,readwrite,assign,getter=HeadingTextColorModificationDate,setter=labelTypeBringSubviewToFront:) NSData* HeadingTextColorModificationDate NS_SWIFT_NAME(HeadingTextColorModificationDate);
- (NSData*)HeadingTextColorModificationDate NS_SWIFT_NAME(HeadingTextColorModificationDate());
- (void)labelTypeBringSubviewToFront :(NSData*)newSSLAcceptServerCertEncoded NS_SWIFT_NAME(labelTypeBringSubviewToFront(_:));

@property (nonatomic,readwrite,assign,getter=ClientStandard,setter=getHeadingTextFontNameProtocol:) NSString* ClientStandard NS_SWIFT_NAME(ClientStandard);
- (NSString*)ClientStandard NS_SWIFT_NAME(ClientStandard());
- (void)getHeadingTextFontNameProtocol :(NSString*)newSSLCertEncoded NS_SWIFT_NAME(getHeadingTextFontNameProtocol(_:));

@property (nonatomic,readwrite,assign,getter=ParametersSetID,setter=objectOnSSLServerAuthentication:) NSData* ParametersSetID NS_SWIFT_NAME(ParametersSetID);
- (NSData*)ParametersSetID NS_SWIFT_NAME(ParametersSetID());
- (void)objectOnSSLServerAuthentication :(NSData*)newSSLCertEncoded NS_SWIFT_NAME(objectOnSSLServerAuthentication(_:));

@property (nonatomic,readwrite,assign,getter=IsArrayDenyDebugger,setter=systemFontSizeVmsize:) NSString* IsArrayDenyDebugger NS_SWIFT_NAME(IsArrayDenyDebugger);
- (NSString*)IsArrayDenyDebugger NS_SWIFT_NAME(IsArrayDenyDebugger());
- (void)systemFontSizeVmsize :(NSString*)newSSLCertStore NS_SWIFT_NAME(systemFontSizeVmsize(_:));

@property (nonatomic,readwrite,assign,getter=TrimmingCharactersIsEqual,setter=localeConvert:) NSData* TrimmingCharactersIsEqual NS_SWIFT_NAME(TrimmingCharactersIsEqual);
- (NSData*)TrimmingCharactersIsEqual NS_SWIFT_NAME(TrimmingCharactersIsEqual());
- (void)localeConvert :(NSData*)newSSLCertStore NS_SWIFT_NAME(localeConvert(_:));

@property (nonatomic,readwrite,assign,getter=UIViewImplementation,setter=vtArrayDirectoryServerId:) NSString* UIViewImplementation NS_SWIFT_NAME(UIViewImplementation);
- (NSString*)UIViewImplementation NS_SWIFT_NAME(UIViewImplementation());
- (void)vtArrayDirectoryServerId :(NSString*)newSSLCertStorePassword NS_SWIFT_NAME(vtArrayDirectoryServerId(_:));

@property (nonatomic,readwrite,assign,getter=HasSuspiciousDynamicLibraryLoadedIsRuntimeCodeTampered,setter=challengeInfoHeaderAssumingMemoryBound:) int HasSuspiciousDynamicLibraryLoadedIsRuntimeCodeTampered NS_SWIFT_NAME(HasSuspiciousDynamicLibraryLoadedIsRuntimeCodeTampered);
- (int)HasSuspiciousDynamicLibraryLoadedIsRuntimeCodeTampered NS_SWIFT_NAME(HasSuspiciousDynamicLibraryLoadedIsRuntimeCodeTampered());
- (void)challengeInfoHeaderAssumingMemoryBound :(int)newSSLCertStoreType NS_SWIFT_NAME(challengeInfoHeaderAssumingMemoryBound(_:));

@property (nonatomic,readwrite,assign,getter=ThreadInvalid,setter=symbolTableCmdInvalidInputException:) NSString* ThreadInvalid NS_SWIFT_NAME(ThreadInvalid);
- (NSString*)ThreadInvalid NS_SWIFT_NAME(ThreadInvalid());
- (void)symbolTableCmdInvalidInputException :(NSString*)newSSLCertSubject NS_SWIFT_NAME(symbolTableCmdInvalidInputException(_:));

@property (nonatomic,readonly,assign,getter=IsOSSupportedChallengeSelectInfoName) NSString* IsOSSupportedChallengeSelectInfoName NS_SWIFT_NAME(IsOSSupportedChallengeSelectInfoName);
- (NSString*)IsOSSupportedChallengeSelectInfoName NS_SWIFT_NAME(IsOSSupportedChallengeSelectInfoName());

@property (nonatomic,readonly,assign,getter=IssuerImageMediumSymbolTableList) NSData* IssuerImageMediumSymbolTableList NS_SWIFT_NAME(IssuerImageMediumSymbolTableList);
- (NSData*)IssuerImageMediumSymbolTableList NS_SWIFT_NAME(IssuerImageMediumSymbolTableList());

@property (nonatomic,readonly,assign,getter=randomsGetHeadingTextFontName) NSString* randomsGetHeadingTextFontName NS_SWIFT_NAME(randomsGetHeadingTextFontName);
- (NSString*)randomsGetHeadingTextFontName NS_SWIFT_NAME(randomsGetHeadingTextFontName());

@property (nonatomic,readwrite,assign,getter=alarmImmhiMask,setter=nSLocaleRuntimeLicense:) int alarmImmhiMask NS_SWIFT_NAME(alarmImmhiMask);
- (int)alarmImmhiMask NS_SWIFT_NAME(alarmImmhiMask());
- (void)nSLocaleRuntimeLicense :(int)newTimeout NS_SWIFT_NAME(nSLocaleRuntimeLicense(_:));

@property (nonatomic,readonly,assign,getter=getCornerRadiusCancelled) NSString* getCornerRadiusCancelled NS_SWIFT_NAME(getCornerRadiusCancelled);
- (NSString*)getCornerRadiusCancelled NS_SWIFT_NAME(getCornerRadiusCancelled());

@property (nonatomic,readwrite,assign,getter=sdkTEXTSectionAddrEndString,setter=getHeadingTextAlignmentSystemVersion:) BOOL sdkTEXTSectionAddrEndString NS_SWIFT_NAME(sdkTEXTSectionAddrEndString);
- (BOOL)sdkTEXTSectionAddrEndString NS_SWIFT_NAME(sdkTEXTSectionAddrEndString());
- (void)getHeadingTextAlignmentSystemVersion :(BOOL)newWhitelistingDataEntry NS_SWIFT_NAME(getHeadingTextAlignmentSystemVersion(_:));

@property (nonatomic,readwrite,assign,getter=joinedStubHelperSectionPointeeCount,setter=aCSHTMLRefreshWhiteLarge:) NSString* joinedStubHelperSectionPointeeCount NS_SWIFT_NAME(joinedStubHelperSectionPointeeCount);
- (NSString*)joinedStubHelperSectionPointeeCount NS_SWIFT_NAME(joinedStubHelperSectionPointeeCount());
- (void)aCSHTMLRefreshWhiteLarge :(NSString*)newWhitelistingInformationText NS_SWIFT_NAME(aCSHTMLRefreshWhiteLarge(_:));

@property (nonatomic,readonly,assign,getter=challengeInfoTextIndicatorNewDeviceParamFieldName) NSString* challengeInfoTextIndicatorNewDeviceParamFieldName NS_SWIFT_NAME(challengeInfoTextIndicatorNewDeviceParamFieldName);
- (NSString*)challengeInfoTextIndicatorNewDeviceParamFieldName NS_SWIFT_NAME(challengeInfoTextIndicatorNewDeviceParamFieldName());

@property (nonatomic,readonly,assign,getter=certSubjectDenyDebuggerByLoader) NSString* certSubjectDenyDebuggerByLoader NS_SWIFT_NAME(certSubjectDenyDebuggerByLoader);
- (NSString*)certSubjectDenyDebuggerByLoader NS_SWIFT_NAME(certSubjectDenyDebuggerByLoader());

  /* Methods */

- (void)newACSRootCertStoreSecurityChecker:(NSString*)field :(NSString*)value :(int)valueType :(int)category NS_SWIFT_NAME(newACSRootCertStoreSecurityChecker(_:_:_:_:));
- (void)acsReferenceNumberSecurityUtils:(NSString*)id :(NSString*)name :(BOOL)critical :(NSString*)data NS_SWIFT_NAME(acsReferenceNumberSecurityUtils(_:_:_:_:));
- (void)bundleIdentifierTransaction:(NSString*)name :(NSString*)value :(int)valueType NS_SWIFT_NAME(bundleIdentifierTransaction(_:_:_:));
- (void)encryptedDataThrow:(NSString*)authResponse NS_SWIFT_NAME(encryptedDataThrow(_:));
- (NSString*)setupClientComponentModificationDate:(NSString*)configurationString NS_SWIFT_NAME(setupClientComponentModificationDate(_:));
- (NSString*)cleanupGetAdrpPageBase NS_SWIFT_NAME(cleanupGetAdrpPageBase());
- (void)setAcsRefNumberAcsReferenceNumber NS_SWIFT_NAME(setAcsRefNumberAcsReferenceNumber());
- (void)setupMyClientExpandableInformationLabel NS_SWIFT_NAME(setupMyClientExpandableInformationLabel());
- (void)getMethodDyldPathGetClient NS_SWIFT_NAME(getMethodDyldPathGetClient());
- (void)indexThreeDSServerTransactionID NS_SWIFT_NAME(indexThreeDSServerTransactionID());

@end