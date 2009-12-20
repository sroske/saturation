//
//  NSArray-Shuffle.h
//  IsIt
//  Stolen from http://iphonedevelopment.blogspot.com/2008/10/shuffling-arrays.html
//

#import "NSArray-Shuffle.h"

@implementation NSArray(Shuffle)
-(NSArray *)shuffledArray
{
  
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
  
  NSMutableArray *copy = [self mutableCopy];
  while ([copy count] > 0)
  {
    int index = arc4random() % [copy count];
    id objectToMove = [copy objectAtIndex:index];
    [array addObject:objectToMove];
    [copy removeObjectAtIndex:index];
  }
  
  [copy release];
  return array;
}
@end