'''
This script is used to get OOVs from the text file of a new data directory
if the lexicon is not made for that directory
'''

import os
import sys
import subprocess
from voiceai.asr.textproc import lex

def get_vocabulary(text_file):
    list_of_words=[]
    with open(text_file) as txt:
        for line in txt.readlines():
            token_counter = 0
            for token in (line.split()):
                if token_counter != 0:
                    list_of_words.append(token.lower())
                token_counter += 1
    return list(set(list_of_words))

def get_lexicon_entries(lexicon):
    lexicon_entries=[]
    with open(lexicon) as lex:
        for l in lex.readlines():
            lexicon_entries.append(l.split()[0].lower())
    return lexicon_entries

def check_if_exists_in_lexicon(list_of_target_words, lexicon):
    words_that_need_care=[]
    lexicon_entries = get_lexicon_entries(lexicon) 
    for target_word in list_of_target_words:
        if target_word not in lexicon_entries:
            words_that_need_care.append(target_word)
    return words_that_need_care


TEXT_FILE='/app/text'
LEXICON='/app/lexicon.txt'

words_to_g2p=(check_if_exists_in_lexicon(get_vocabulary(TEXT_FILE), LEXICON))
with open('/app/words_to_g2p.txt', 'w') as out_file:
    for word in words_to_g2p:
        out_file.write(word+"\n")

print('Number of unk tokens in courpus:\t'+str(len(words_to_g2p)))

os.system("Phonetisaurus/phonetisaurus-g2pfst --model=/app/g2p.fst --wordlist=/app/words_to_g2p.txt --nbest=3 >> /app/oov_pronunciations.txt")  
