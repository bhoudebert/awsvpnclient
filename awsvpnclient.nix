{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, openvpn
, sudo
, xdg-utils
}:

buildGoModule rec {
  pname = "awsvpnclient";
  version = "d21871174947c311be989cc7ade675e7f74e3808";
  #version = "bc3df0c730a4b27d34dfce9f843f87ee611cbb38";

  src = fetchFromGitHub {
    owner = "ajm113";
    repo = "aws-vpn-client";
    rev = "${version}";
    sha256 = "sha256-vJRQnTzJuhpYxG8YhH+QcZoRwvuuUzFOpunNo9mrfwI=";
  };

  vendorSha256 = "sha256-602xj0ffJXQW//cQeByJjtQnU0NjqOrZWTCWLLhqMm0=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    cp ${src}/awsvpnclient.yml.example $out/awsvpnclient.yml

    substituteInPlace $out/awsvpnclient.yml \
      --replace /home/myname/aws-vpn-client/openvpn "openvpn" \
      --replace /usr/bin/sudo "/run/wrappers/bin/sudo"

    makeWrapper $out/bin/aws-vpn-client $out/bin/awsvpnclient \
      --run "cd $out" \
      --prefix PATH : "${lib.makeBinPath [ openvpn xdg-utils sudo ]}"
  '';

}
