#!/bin/bash

## DELETE LOGO
rm /usr/share/grub/themes/manjaro/logo.png

## COPY OVER NEW LOGO
cp logo.png /usr/share/grub/themes/manjaro/

## DELETE BACKGROUND
rm /usr/share/grub/themes/manjaro/background.png
#rm /usr/share/grub/themes/background.png

## COPY OVER NEW BACKGROUND
cp background.png /usr/share/grub/themes/manjaro/
cp background.png /usr/share/grub/themes/

## ALL ACCESS 
chmod 777 /usr/share/grub/themes/manjaro/logo.png
chmod 777 /usr/share/grub/themes/manjaro/background.png
