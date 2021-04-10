#!/bin/bash



aviso_instalador="<big><b>Lembrete amigável</b></big>

Pra você abrir esse arquivo é necessário instalar um software especial
para que o  TigerOS possa decodifica-lo.  Essa ação precisa  ser feita 
apenas uma vez e habilitará o suporte a:

    • DVDs protegidos por região
    • Fontes principais da Microsoft
    • Suporte a arquivos .RAR
    • Suporte a arquivos .SWF
    • Praticamente todos os codecs de vídeo
    • E uma infinidade de arquivos compactados

Todos eles são gratuitos e podem ser instalados legalmente através 
dessa janela, para prosseguir com a intalação clique em <b>Instalar</b>,
note que ao instalar você concorda com o texto que trata da licença 
desses sofwares na documentação do Tiger OS, você será avisado quando 
a instalação terminar

"

aviso_instalador_do_menu="Bem-vindo(a) ao instalador de recursos adicionais, caso porossiga com
a instalação, os seguintes recursos proprietário serão habilitados no
Tiger Os:

    • DVDs protegidos por região
    • Fontes principais da Microsoft
    • Suporte a arquivos .RAR
    • Suporte a arquivos .SWF
    • Praticamente todos os codecs de vídeo
    • E uma infinidade de arquivos compactados

Todos eles são gratuitos e podem ser instalados legalmente através 
dessa janela, para prosseguir com a intalação clique em <b>Instalar</b>,
note que ao instalar você concorda com o texto que trata da licença 
desses sofwares na documentação do Tiger OS, você será avisado quando 
a instalação terminar

"

aviso_sucesso="<big><b>A instalação foi um sucesso</b></big>

Agora você pode aproveitar os novos recursos do Tiger OS
que são protegidos por direitos autorais
"

aviso_erro="<big><b>Oops, Ocorreu um erro :(</b></big>

Reinicie o sistema e tente de novamente, antes da próxima tentativa 
verifique se a internet está funcionando corretamente, que você 
digitou sua senha corretamente e que você possui permissão para isso
caso esteja em uma empresa
"

titulo="Tiger OS - Informativo"

[ "${1}" = "--silent" ] && {
  [ ! "${EUID}" = "0" ] && {
    echo "Você precisa executar esse instalador como root, para isso execute:"
    echo
    echo "  sudo \"${0}\" --silent "
    echo
    exit 1
  }
  
  # Comando que instala os codecs
  export DEBIAN_FRONTEND=noninteractive
  echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
  
  
  apt install ttf-mscorefonts-installer p7zip-full ubuntu-restricted-extras rar unrar -y || exit 1
  
  cd $(mktemp -d)
  
  # Instala o Flash Player Projector
  
  wget "https://web.archive.org/web/20210322190532/https://fpdownload.macromedia.com/pub/flashplayer/updaters/32/flash_player_sa_linux.x86_64.tar.gz" || exit 1
  tar -xvf "flash_player_sa_linux.x86_64.tar.gz" || exit 1
  chmod +x "flashplayer"
  mv "flashplayer" /usr/bin
  
  (echo "[Desktop Entry]"
  echo "Name=Adobe Flash Projector"
  echo "Exec=flashplayer %f"
  echo "Icon=adobe-flashplayer"
  echo "Type=Application"
  echo "Categories=Utility;"
  echo "MimeType=application/vnd.adobe.flash.movie;") > "/usr/share/applications/flashplayer.desktop"
  
  rm /usr/share/applications/codecs-installer.desktop
  update-desktop-database /usr/share/applications/
  exit
}

[ ! -f "${1}" ] && {
  aviso_instalador="${aviso_instalador_do_menu}"
  titulo="Tiger OS - Instalador de Recursos Adicionais"
}

yad --text="${aviso_instalador}" --button="Cancelar":0 --button="<b>Instalar</b>":1 --borders=32 --center --fixed --title="${titulo}" --window-icon=preferences-plugin

[ "${?}" = "1" ] && {
     cmd=$(readlink -f "${0}")
     pkexec "${cmd}" --silent && {
     yad --text="${aviso_sucesso}" --button=Ok --fixed --center --borders=32 --title="Tiger OS - Informativo" --window-icon=preferences-plugin
     [ -f "${1}" ] && {
       xdg-open "${1}"
     }
     exit
   } || {
     yad --text="${aviso_erro}" --button=Ok --fixed --center --borders=32 --title="Tiger OS - Informativo" --window-icon=preferences-plugin
     exit 1
   }
}

