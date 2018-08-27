#import <Carbon/Carbon.h>

// Théo Winterhalter
// https://stackoverflow.com/users/1275975/th%c3%a9o-winterhalter
// https://stackoverflow.com/questions/1918841/how-to-convert-ascii-character-to-cgkeycode/33584460#33584460

NSString* keyCodeToString(CGKeyCode keyCode)
{
  TISInputSourceRef currentKeyboard = TISCopyCurrentKeyboardInputSource();
  CFDataRef uchr =
    (CFDataRef)TISGetInputSourceProperty(currentKeyboard,
                                         kTISPropertyUnicodeKeyLayoutData);
  const UCKeyboardLayout *keyboardLayout =
    (const UCKeyboardLayout*)CFDataGetBytePtr(uchr);

  if(keyboardLayout)
  {
    UInt32 deadKeyState = 0;
    UniCharCount maxStringLength = 255;
    UniCharCount actualStringLength = 0;
    UniChar unicodeString[maxStringLength];

    OSStatus status = UCKeyTranslate(keyboardLayout,
                                     keyCode, kUCKeyActionDown, 0,
                                     LMGetKbdType(), 0,
                                     &deadKeyState,
                                     maxStringLength,
                                     &actualStringLength, unicodeString);

    if (actualStringLength == 0 && deadKeyState)
    {
      status = UCKeyTranslate(keyboardLayout,
                                       kVK_Space, kUCKeyActionDown, 0,
                                       LMGetKbdType(), 0,
                                       &deadKeyState,
                                       maxStringLength,
                                       &actualStringLength, unicodeString);
    }
    if(actualStringLength > 0 && status == noErr)
      return [[NSString stringWithCharacters:unicodeString
                        length:(NSUInteger)actualStringLength] lowercaseString];
  }

  return nil;
}

NSNumber* charToKeyCode(const char c)
{
  static NSMutableDictionary* dict = nil;

  if (dict == nil)
  {
    dict = [NSMutableDictionary dictionary];

    // For every keyCode
    int i;
    for (i = 0; i < 128; ++i)
    {
      NSString* str = keyCodeToString((CGKeyCode)i);
      if(str != nil && ![str isEqualToString:@""])
      {
        [dict setObject:[NSNumber numberWithInt:i] forKey:str];
      }
    }
  }

  NSString * keyChar = [NSString stringWithFormat:@"%c" , c];

  return [dict objectForKey:keyChar];
}
