import Link from "next/link"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { GraduationCap, Calendar, Bell, BookOpen, Compass } from "lucide-react"
import { ChatBot } from "@/components/chat-bot"
import { Footer } from "@/components/footer"
import { EngineeringIcon } from "@/components/ui/engineering-icon"
import { COLLEGE_INFO, THEME } from "@/lib/constants"
import { cn } from "@/lib/utils"
import { ThemeSwitcher } from "@/components/theme-switcher"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"

export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-b from-blue-50 to-white dark:from-gray-900 dark:to-gray-950 dark:text-white">
      <header className="bg-white dark:bg-gray-900 shadow-md sticky top-0 z-30">
        <div className="container mx-auto px-4 py-4 flex justify-between items-center">
          <div className="flex items-center gap-3">
            <GraduationCap className={cn("h-10 w-10", THEME.colors.primary.text)} />
            <div>
              <h1 className="text-xl font-bold text-blue-900 dark:text-blue-400">{COLLEGE_INFO.shortName}</h1>
              <p className="text-sm text-blue-700 dark:text-blue-500">Student Information System</p>
            </div>
          </div>
          <div className="flex gap-4 items-center">
            <Link href="/login">
              <Button variant="outline" className={THEME.transitions.fast}>
                Login
              </Button>
            </Link>
            <Link href="/about">
              <Button variant="ghost" className={THEME.transitions.fast}>
                About
              </Button>
            </Link>
            <Link href="/contact">
              <Button variant="ghost" className={THEME.transitions.fast}>
                Contact
              </Button>
            </Link>
            <ThemeSwitcher />
          </div>
        </div>
      </header>

      <main className="container mx-auto px-4 py-12">
        <section className="mb-16 text-center">
          <h1 className="text-4xl font-bold text-blue-900 dark:text-blue-400 mb-4">{COLLEGE_INFO.name}</h1>
          <p className="text-xl text-blue-700 dark:text-blue-500 mb-8">{COLLEGE_INFO.location}</p>
          <p className="max-w-2xl mx-auto text-gray-600 dark:text-gray-400 mb-8">
            Welcome to the Student Information System - your comprehensive portal for academic management, course
            information, and campus resources.
          </p>
          <div className="flex justify-center gap-4">
            <Link href="/login?role=student">
              <Button
                size="lg"
                className={cn(THEME.colors.primary.main, THEME.colors.primary.hover, THEME.transitions.normal)}
              >
                Student Login
              </Button>
            </Link>
            <Link href="/login?role=faculty">
              <Button size="lg" variant="outline" className={THEME.transitions.normal}>
                Faculty Login
              </Button>
            </Link>
          </div>
        </section>

        <Tabs defaultValue="academics" className="w-full">
          <TabsList className="grid grid-cols-1 md:grid-cols-3">
            <TabsTrigger value="academics">
              <BookOpen className="mr-2 h-4 w-4" />
              Academics
            </TabsTrigger>
            <TabsTrigger value="facilities">
              <Compass className="mr-2 h-4 w-4" />
              Facilities
            </TabsTrigger>
            <TabsTrigger value="announcements">
              <Bell className="mr-2 h-4 w-4" />
              Announcements
            </TabsTrigger>
          </TabsList>
          <TabsContent value="academics" className="mt-6">
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              <Link href="/academics">
                <Card className={cn("border-blue-100 dark:border-blue-900 hover:shadow-lg", THEME.transitions.normal)}>
                  <CardContent className="p-6">
                    <div className="flex items-start gap-4">
                      <div className={cn("p-3 rounded-lg", THEME.colors.primary.light)}>
                        <EngineeringIcon name="binary" className={cn("h-6 w-6", THEME.colors.primary.text)} />
                      </div>
                      <div>
                        <h3 className="text-lg font-semibold mb-2">Academic Programs</h3>
                        <p className="text-gray-600 dark:text-gray-400">
                          Explore our five engineering branches: CSE, IT, ENTC, ELPO, and Mechanical.
                        </p>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              </Link>
              <Link href="/academics#calendar">
                <Card className={cn("border-blue-100 dark:border-blue-900 hover:shadow-lg", THEME.transitions.normal)}>
                  <CardContent className="p-6">
                    <div className="flex items-start gap-4">
                      <div className={cn("p-3 rounded-lg", THEME.colors.primary.light)}>
                        <Calendar className={cn("h-6 w-6", THEME.colors.primary.text)} />
                      </div>
                      <div>
                        <h3 className="text-lg font-semibold mb-2">Academic Calendar</h3>
                        <p className="text-gray-600 dark:text-gray-400">
                          Stay updated with important dates, events, and exam schedules.
                        </p>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              </Link>
            </div>
          </TabsContent>
          <TabsContent value="facilities" className="mt-6">
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              <Link href="/facilities">
                <Card className={cn("border-blue-100 dark:border-blue-900 hover:shadow-lg", THEME.transitions.normal)}>
                  <CardContent className="p-6">
                    <div className="flex items-start gap-4">
                      <div className={cn("p-3 rounded-lg", THEME.colors.primary.light)}>
                        <EngineeringIcon name="compass" className={cn("h-6 w-6", THEME.colors.primary.text)} />
                      </div>
                      <div>
                        <h3 className="text-lg font-semibold mb-2">Campus Facilities</h3>
                        <p className="text-gray-600 dark:text-gray-400">
                          Information about labs, libraries, and other campus resources.
                        </p>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              </Link>
            </div>
          </TabsContent>
          <TabsContent value="announcements" className="mt-6">
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              <Link href="/announcements">
                <Card className={cn("border-blue-100 dark:border-blue-900 hover:shadow-lg", THEME.transitions.normal)}>
                  <CardContent className="p-6">
                    <div className="flex items-start gap-4">
                      <div className={cn("p-3 rounded-lg", THEME.colors.primary.light)}>
                        <Bell className={cn("h-6 w-6", THEME.colors.primary.text)} />
                      </div>
                      <div>
                        <h3 className="text-lg font-semibold mb-2">Announcements</h3>
                        <p className="text-gray-600 dark:text-gray-400">
                          Get the latest news, updates, and important announcements.
                        </p>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              </Link>
            </div>
          </TabsContent>
        </Tabs>

        <section className={cn("rounded-xl p-8 mb-16", THEME.colors.primary.light)}>
          <h2 className="text-2xl font-bold text-blue-900 dark:text-blue-400 mb-6 text-center">
            Engineering Excellence
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-5 gap-6 text-center">
            {COLLEGE_INFO.departments.map((dept) => (
              <div key={dept.code} className="p-4">
                <h3 className="font-semibold text-blue-800 dark:text-blue-400 mb-2">{dept.code}</h3>
                <p className="text-gray-600 dark:text-gray-400">{dept.name}</p>
              </div>
            ))}
          </div>
        </section>
      </main>

      <Footer />
      <ChatBot />
    </div>
  )
}

