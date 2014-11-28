module Control.Timer where

import Control.Monad.Eff

foreign import data Timer     :: !
foreign import data Timeout   :: *
foreign import data Interval  :: *

type Milliseconds = Number

type EffTimer e a = Eff (timer :: Timer | e) a

foreign import timeout """
  function timeout(time){                     
    var win = typeof global !== 'undefined' ? global : window;
    return function(fn){                     
      return function(){                     
        return win.setTimeout(function(){
          fn();                              
        }, time);                            
      };                                     
    };                                       
  }
""" :: forall a e. Milliseconds -> EffTimer e a -> EffTimer e Timeout

foreign import clearTimeout """
  function clearTimeout(timer){
    var win = typeof global !== 'undefined' ? global : window;
    return function(){
      return win.clearTimeout(timer);
    };
  }
""" :: forall e. Timeout -> EffTimer e Unit

foreign import interval """
  function interval(time){
    var win = typeof global !== 'undefined' ? global : window;
    return function(fn){
      return function(){
        return win.setInterval(function(){
          fn();
        }, time);
      };
    };
  }
""" :: forall a e. Milliseconds -> EffTimer e a -> EffTimer e Interval

foreign import clearInterval """
  function clearInterval(timer){
    var win = typeof global !== 'undefined' ? global : window;
    return function(){
      return win.clearInterval(timer);
    };
  }
""" :: forall e. Interval -> EffTimer e Unit
