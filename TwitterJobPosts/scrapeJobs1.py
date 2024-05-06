# First step involves importing the libraries to use
import requests
from bs4 import BeautifulSoup


def scrapping_data():
    # define a web scrapping function
    job_posts = []
    jobs_url = "https://www.brightermonday.co.ke/jobs?experience=graduate-trainee"
    response = requests.get(jobs_url)
    if response.status_code == 200:
        html_text = response.text
    else:
        print("Failed to fetch jobs")
        exit()

    # Instantiate BeautifulSoup and pass data
    job_list = BeautifulSoup(html_text, "lxml")
    for job in job_list.find_all('div', class_="mx-5 md:mx-0 flex flex-wrap col-span-1 mb-5 bg-white rounded-lg border "
                                               "border-gray-300 hover:border-gray-400 focus-within:ring-2 "
                                               "focus-within:ring-offset-2 focus-within:ring-gray-500"):

        # Obtain the date posted
        date_posted = job_list.find('p',
                                    class_="ml-auto text-sm font-normal text-gray-700 text-loading-animate").text.strip()

        # Filter by date posted
        if 'days' in date_posted:
            job_link = job_list.find('a', class_="relative mb-3 text-lg font-medium break-words focus:outline-none "
                                                 "metrics-apply-now "
                                                 "text-link-500 text-loading-animate")['href']
            job_details = {}
            detail_response = requests.get(job_link)
            if response.status_code == 200:
                job_text = detail_response.text
            else:
                print("Could not fetch job details")
                exit()

            # Scrap data for individual job details
            job_detail = BeautifulSoup(job_text, "lxml")

            job_title = job_detail.find('h1',
                                        class_="mt-6 mb-3 text-lg font-medium text-gray-700 md:mb-4 md:mt-0").text.strip()
            job_qualification = job_detail.find('span', class_="pb-1 text-gray-500").text.strip()
            company = job_detail.find('h2', class_="pb-1 text-sm font-normal").text.strip()
            job_locale = job_detail.find('a', class_="text-sm font-normal px-3 rounded bg-brand-secondary-50 mr-2 mb-3 "
                                                     "inline-block").text.strip()
            job_fields = job_detail.find('a', class_="text-sm font-normal px-3 rounded bg-brand-secondary-50 mr-2 mb-3 "
                                                     "inline-block").text.strip()

            # Append scrapped data to list
            job_posts.append(
                {'title': job_title, 'company': company, 'link': job_link, 'qualification': job_qualification,
                 'Locale': job_locale, 'field': job_fields, 'Date Posted': date_posted})

            for job_post in job_posts:
                

    return job_posts
