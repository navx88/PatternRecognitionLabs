clear all;
close all;
clc;

load('feat.mat');

[p, i] = Kmeans(f32,10);
% idx = kmeans(f32.',10)
[c, U] = fcm(f32(1:2,:).',10);

i

figure(1)
aplot(f32);
hold on
scatter(p(1,:),p(2,:),'LineWidth',1.5);

figure(2)
aplot(f32);
hold on
scatter(c(:,1),c(:,2),'LineWidth',1.5);