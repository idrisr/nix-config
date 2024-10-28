{
  config.services.hoogle = {
    enable = true;
    packages = hp:
      with hp; [
        brick
        cassava
        checkers
        conduit
        falsify
        hakyll
        hedgehog
        JuicyPixels
        lens
        lens-aeson
        monadIO
        mtl_2_3_1
        pdf-toolbox-content
        pdf-toolbox-core
        pdf-toolbox-document
        persistent
        persistent-sqlite
        pipes
        QuickCheck
        smallcheck
        streaming
        tasty
        tasty-hunit
        tasty-quickcheck
        test-invariant
        text-format
        transformers_0_6_1_1
        turtle
        xmonad
      ];
  };
}
