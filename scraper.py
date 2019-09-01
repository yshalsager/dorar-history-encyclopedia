#!/usr/bin/env python3.7

from bs4 import BeautifulSoup
from requests import get


def scraper(last: int):
    counter = 1
    for i in range(1, last + 1):
        page = BeautifulSoup(get(f'https://dorar.net/history/?page={i}').content,
                             'html.parser').find('div', {'class': 'text-justify rtl'})
        items = page.findAll('div', {'class': 'panel panel-theme2'})
        for item in items:
            title = item.find('h4', {'class': 'panel-title'}).text.strip()
            data = item.findAll('p')
            date1, date2, date3 = '', '', ''
            if len(data) == 4:
                date1 = data[0].text.strip()
                date2 = data[1].text.strip()
            elif len(data) == 5:
                date1 = data[0].text.strip()
                date2 = data[1].text.strip()
                date3 = data[2].text.strip()
            details = data[-1].text.strip()
            with open(f'out/{counter}.md', 'w') as output:
                output.writelines(f'<h1 dir="rtl">{title}</h1>\n\n')
                output.writelines(f'<h5 dir="rtl">{date1}\n\n{date2}\n\n{date3}</h5>\n\n')
                output.writelines(f'<p dir="rtl">{details}</p></br>\n')
            counter += 1


def get_last_page():
    return BeautifulSoup(
        get(f'https://dorar.net/history/').content,
        'html.parser').find('ul', {'class': 'pagination pagination-lg'}
                            ).findAll('a')[-1]['href'].split('=')[1]


def main():
    last = int(get_last_page())
    scraper(last)


if __name__ == '__main__':
    main()
