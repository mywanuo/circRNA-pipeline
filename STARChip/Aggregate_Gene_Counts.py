#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Feb 26 14:24:05 2019

@author: jishu
"""

import pandas as pd
import os
from os.path import basename
import glob


def merge_genes_files(files,output):
    cgenes = pd.DataFrame()
    for f in files:
        df = pd.read_csv(f,sep="\t",delimiter='\t',index_col='ID')
        if cgenes.shape == (0,0):
            cgenes = df
        else:
            cgenes=cgenes.combine_first(df)
    cgenes.index.name='cRNA'
    cgenes.to_csv(output, index=True)
     
def merge_annotation(files,output):
    cannotation=pd.DataFrame()
    for f in files:
        df = pd.read_csv(f,sep="\t",delimiter='\t',index_col='cRNA')
        if cannotation.shape == (0,0):
            cannotation = df
        else:
            cannotation=cannotation.combine_first(df)
    cannotation.index.name='cRNA'
    cannotation.to_csv(output, index=True)
def merge_gene_countmatrix(files,output):
    cmatrix = pd.DataFrame()
    # loop through input files
    for f in files:
        df = pd.read_csv(f,sep="\t",delimiter='\t',index_col='cRNA')
        if cmatrix.shape == (0,0):
            cmatrix = df
        else:
            cmatrix = pd.concat([cmatrix, df], axis=1, sort=False)
    # round matrix by 3 digits
    #cmatrix = cmatrix.round(3)
    cmatrix.index.name='cRNA'
    cmatrix.to_csv(output, index=True)

def main():
    FILES_DIR = os.path.dirname(os.path.dirname((os.path.dirname(os.environ['INPUT_FILE_1']))))
    print(FILES_DIR)
    FILE_NAME = os.path.basename(os.environ['INPUT_FILE_1'])
    print(FILE_NAME)
    FILES=glob.glob(FILES_DIR+"/*/starchip/"+FILE_NAME)
    print(FILES)
    OUTPUT_NAME = os.environ['OUTPUT_FILE']
    TAB_NAME = os.environ['TAB_NAME']
    if TAB_NAME == "genes":
        merge_genes_files(FILES, OUTPUT_NAME)
    elif TAB_NAME == "countmatrix":
        merge_gene_countmatrix(FILES,OUTPUT_NAME)
    elif TAB_NAME == "annotated":
        merge_annotation(FILES, OUTPUT_NAME)
        
if __name__ == "__main__":
    main()
