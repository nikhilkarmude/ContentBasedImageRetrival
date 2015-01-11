clear all;
close all;
% process DB
Dir='D:\visionDB';
ProcessDB(Dir);

% take query image and compare

A= imread('D:\Vision Lectures\inputimage\inp1.jpg');

% compare my histogram with ProcessDB database
compare(A);