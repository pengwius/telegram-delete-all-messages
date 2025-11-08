with import <nixpkgs> {};
let
  pythonEnv = python3.withPackages (ps: with ps; [ pyrogram tgcrypto ]);
in
stdenv.mkDerivation {
  name = "telegram-delete-all-messages";
  src = ./.;
  buildInputs = [ pythonEnv ];
  installPhase = ''
    mkdir -p $out/lib/telegram-delete-all-messages
    cp -r $src/* $out/lib/telegram-delete-all-messages/
    mkdir -p $out/bin
    cat > $out/bin/telegram-delete-all-messages <<'EOF'
#!${pythonEnv}/bin/python3
import runpy, sys
runpy.run_path("$out/lib/telegram-delete-all-messages/cleaner.py", run_name="__main__")
EOF
    chmod +x $out/bin/telegram-delete-all-messages
  '';
  meta = with lib; {
    description = "Utility to delete all your Telegram messages in selected chats";
    # NOTE: set the correct license before submitting to nixpkgs
    license = lib.licenses.mit;
  };
}
