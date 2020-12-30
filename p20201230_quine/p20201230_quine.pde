String tekst = "String tekst = %q%tekst%q;\ntext(tekst, 10, 10);";
tekst = tekst.replace("%tekst", tekst);
tekst = tekst.replace("%q", Character.toString((char) 34));
size(600, 600);
text(tekst, 10, 10);
