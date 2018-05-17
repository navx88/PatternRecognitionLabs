clear all;
close all;
clc;

load('feat.mat');

[confusion_matrix_2 , error_rate_2 ] = micd_confusion_analysis(f2 , f2t )
[confusion_matrix_8 , error_rate_8 ] = micd_confusion_analysis(f8 , f8t )
[confusion_matrix_32, error_rate_32] = micd_confusion_analysis(f32, f32t)